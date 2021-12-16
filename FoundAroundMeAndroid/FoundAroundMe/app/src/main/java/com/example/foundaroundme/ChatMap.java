package com.example.foundaroundme;

import android.Manifest;
import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Address;
import android.location.Geocoder;
import android.location.Location;
import android.location.LocationManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Looper;
import android.preference.PreferenceManager;
import android.provider.Settings;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.DocumentChange;
import com.google.firebase.firestore.EventListener;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.FirebaseFirestoreException;
import com.google.firebase.firestore.ListenerRegistration;
import com.google.firebase.firestore.QuerySnapshot;

import org.osmdroid.api.IMapController;
import org.osmdroid.config.Configuration;
import org.osmdroid.config.IConfigurationProvider;
import org.osmdroid.tileprovider.tilesource.TileSourceFactory;
import org.osmdroid.util.GeoPoint;
import org.osmdroid.views.MapView;
import org.osmdroid.views.overlay.ItemizedIconOverlay;
import org.osmdroid.views.overlay.ItemizedOverlayWithFocus;
import org.osmdroid.views.overlay.OverlayItem;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/*
 * ChatMap is class extends AppCompatActivity. this class is used for the chat activity.
 *
 *
 */
public class ChatMap extends AppCompatActivity {
    public static final String TAG = "TAG";
    private MapView mapView;
    private GeoPoint statPoint;
    private FusedLocationProviderClient fused;
    private TextView txt;
    private IMapController mapController;
    private EditText message;
    private FirebaseFirestore fStore;
    private LinearLayout ll;
    private String location;
    private TextView chan;
    private String chanBefore;
    private ListenerRegistration registration;

    /**
     * Oncreate initialised the map on the screen and instantiate the atribute like the TextView, the ScrollView.
     * @param savedInstanceState
     */

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.location = "";
        fStore = FirebaseFirestore.getInstance();
        //Gestion de cache pour la carte
        IConfigurationProvider osmConf = Configuration.getInstance();
        File basePath = new File(getCacheDir().getAbsolutePath(), "osmdroid");
        osmConf.setOsmdroidBasePath(basePath);
        File tileCache = new File(osmConf.getOsmdroidBasePath().getAbsolutePath(), "tile");
        osmConf.setOsmdroidTileCache(tileCache);
        //Cahcher la bar
        getSupportActionBar().hide();
        setContentView(R.layout.activity_chat_map);
        this.chan = findViewById(R.id.labelChannel);
        this.chan.setText(UserAccess.user.getChannel());
        this.chanBefore = UserAccess.user.getChannel();
        ll = findViewById(R.id.chatBox);
        registration = null;
        triggerMSG();
        message = findViewById(R.id.chat);
        fused = LocationServices.getFusedLocationProviderClient(this);
        checkCondition();
        txt = findViewById(R.id.labelCity);
        Configuration.getInstance().load(getApplicationContext(),
                PreferenceManager.getDefaultSharedPreferences(getApplicationContext()));
        mapView = findViewById(R.id.mapView);
        mapView.setTileSource(TileSourceFactory.MAPNIK);//render
        mapView.setBuiltInZoomControls(false);//zoomable
        mapController = mapView.getController();
        mapController.setZoom(19);

    }

    /**
     * the methode OnResume() check your actual position when you return in this application.
     */
    //@Override
    protected void onResume() {
        super.onResume();
        checkCondition();
    }

    /**
     * Check if your localisation is active and is autorized, if your location is not On the application display the localisation settings.
     */

    public synchronized void checkCondition() {
        if (ActivityCompat.checkSelfPermission(ChatMap.this,
                Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED
                && ActivityCompat.checkSelfPermission(ChatMap.this
                , Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED){
            getCurrentLocation();
        } else {
            ActivityCompat.requestPermissions(ChatMap.this,
                    new String[]{Manifest.permission.ACCESS_FINE_LOCATION,
                            Manifest.permission.ACCESS_COARSE_LOCATION},100);
        }
    }

    /**
     * onRequestPermissionsResult check if you have autorized the application to use your location if is not autozized make text with Permision denied and is dificult to use the app
     * @param requestCode
     * @param permissions
     * @param grantResults
     */

    @Override
    public synchronized void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        if(requestCode == 100 && grantResults.length > 0 && (grantResults[0]+grantResults[1]
                ==PackageManager.PERMISSION_GRANTED)){
            getCurrentLocation();
        } else {
            Toast.makeText(getApplicationContext(),"Permission denied",Toast.LENGTH_SHORT).show();
        }
    }

    /**
     * getCurrentLocation give to the application your location with latitude longitude and the name of your city
     */
    @SuppressLint("MissingPermission")
    private synchronized void getCurrentLocation(){
        LocationManager locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
        if(locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)
                || locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)){
            //location service enable
            this.fused.getLastLocation().addOnCompleteListener(new OnCompleteListener<Location>() {
                @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR2)
                @Override
                public void onComplete(@NonNull Task<Location> task) {
                    Location location = task.getResult();

                    if(location != null){
                        //txt.setText(location.getLatitude()+" "+location.getLongitude());
                        Geocoder geo = new Geocoder(ChatMap.this, Locale.getDefault());
                        try {
                            List<Address> address = geo.getFromLocation(location.getLatitude(),location.getLongitude(),1);
                            txt.setText(address.get(0).getLocality());
                            ChatMap.this.location = address.get(0).getLocality();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }

                        statPoint = new GeoPoint(location.getLatitude(),location.getLongitude());
                        mapController.setCenter(statPoint);
                        ArrayList<OverlayItem> item = new ArrayList<OverlayItem>();
                        item.add(new OverlayItem("votre position","pos", statPoint));
                        ItemizedOverlayWithFocus<OverlayItem> mOverlay = new ItemizedOverlayWithFocus<OverlayItem>(getApplicationContext(), item,
                                new ItemizedIconOverlay.OnItemGestureListener<OverlayItem>() {
                                    @Override
                                    public boolean onItemSingleTapUp(int index, OverlayItem item) {
                                        Log.d("tag","appuyer une fois");
                                        return false;

                                    }
                                    @Override
                                    public boolean onItemLongPress(int index, OverlayItem item) {
                                        Log.d("tag","appuyer lontemps");
                                        return false;
                                    }
                                });
                        mapView.getOverlays().add(mOverlay);

                    } else {
                        LocationRequest locationRequest = new LocationRequest()
                                .setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY)
                                .setInterval(10000)
                                .setFastestInterval(1000)
                                .setNumUpdates(1);
                        LocationCallback locationCallback = new LocationCallback(){
                            @Override
                            public void onLocationResult(LocationResult locationResult) {
                                Location location1 = locationResult.getLastLocation();
                                statPoint = new GeoPoint(location1.getLatitude(),location1.getLongitude());
                                mapController.setCenter(statPoint);
                            }
                        };
                        fused.requestLocationUpdates(locationRequest,locationCallback, Looper.myLooper());
                    }
                }
            });
        } else {
            startActivity(new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS).setFlags(Intent.FLAG_ACTIVITY_NEW_TASK));
        }
    }

    /**
     * this method was called when your click in the buttom send is check of your message is not empty and after that send your message in the firecloud
     * @param v
     */
    public void sendMessage(View v) {

        if (this.message != null &&!this.message.getText().toString().isEmpty()) {

            String test = this.message.getText().toString();
            message.setText("");
            Calendar current = Calendar.getInstance();
            Date dateCreation = current.getTime();
            Map<String, Object> users = new HashMap<>();
            users.put("channel",UserAccess.user.getChannel() );
            users.put("email",UserAccess.user.getEmail() );
            users.put("message",test );
            users.put("city",location );
            users.put("dateCreation", dateCreation);
            users.put("pseudo", UserAccess.user.getPseudo());

            ChatMap.this.fStore.collection("messagesHub").document().set(users).addOnSuccessListener(new OnSuccessListener<Void>() {
                @Override
                public void onSuccess(Void aVoid) {
                    Log.d(TAG, "DocumentSnapshot successfully written!");
                }
            }).addOnFailureListener(new OnFailureListener() {
                @Override
                public void onFailure(@NonNull Exception e) {
                    Log.w(TAG, "Error writing document", e);
                }
            });
        }
    }

    /**
     * when the user click in the text view of channel and want to change the channel
     * @param v
     */
    public void changeChannel(View v){
        CustomPopup customPopup = new CustomPopup(this);
        customPopup.getTransport().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(UserAccess.user.getChannel().equals("Général")){
                    ChatMap.this.chan.setText(customPopup.getTransport().getText());
                    UserAccess.user.setChannel(customPopup.getTransport().getText()+"");
                    ChatMap.this.ll.removeAllViews();
                    triggerMSG();
                } else {
                    if(!UserAccess.user.getChannel().equals("boardGame")){
                        ChatMap.this.chanBefore = UserAccess.user.getChannel();
                        ChatMap.this.chan.setText(customPopup.getTransport().getText());
                        UserAccess.user.setChannel(customPopup.getTransport().getText()+"");
                        ChatMap.this.ll.removeAllViews();
                        triggerMSGOtherChan();
                    }
                }
                customPopup.dismiss();
            }
        });

        customPopup.getRestauration().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(UserAccess.user.getChannel().equals("Général")){
                    ChatMap.this.chan.setText(customPopup.getRestauration().getText());
                    UserAccess.user.setChannel(customPopup.getRestauration().getText()+"");
                    ChatMap.this.ll.removeAllViewsInLayout();
                    triggerMSG();
                } else {
                    if(!UserAccess.user.getChannel().equals("Restauration")){
                        ChatMap.this.chanBefore = UserAccess.user.getChannel();
                        ChatMap.this.chan.setText(customPopup.getRestauration().getText());
                        UserAccess.user.setChannel(customPopup.getRestauration().getText()+"");
                        ChatMap.this.ll.removeAllViewsInLayout();
                        triggerMSGOtherChan();
                    }
                }
                customPopup.dismiss();
            }
        });

        customPopup.getCulture().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(UserAccess.user.getChannel().equals("Général")){
                    ChatMap.this.chan.setText(customPopup.getCulture().getText());
                    UserAccess.user.setChannel(customPopup.getCulture().getText()+"");
                    ChatMap.this.ll.removeAllViewsInLayout();
                    triggerMSG();
                } else {
                    if(!UserAccess.user.getChannel().equals("Culture")){
                        ChatMap.this.chanBefore = UserAccess.user.getChannel();
                        ChatMap.this.chan.setText(customPopup.getCulture().getText());
                        UserAccess.user.setChannel(customPopup.getCulture().getText()+"");
                        ChatMap.this.ll.removeAllViewsInLayout();
                        triggerMSGOtherChan();
                    }
                }
                customPopup.dismiss();
            }
        });

        customPopup.getJeuxVideo().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(UserAccess.user.getChannel().equals("Général")){
                    ChatMap.this.chan.setText(customPopup.getJeuxVideo().getText());
                    UserAccess.user.setChannel(customPopup.getJeuxVideo().getText()+"");
                    ChatMap.this.ll.removeAllViewsInLayout();
                    triggerMSG();
                } else {
                    if(!UserAccess.user.getChannel().equals("JeuxVideo")){
                        ChatMap.this.chanBefore = UserAccess.user.getChannel();
                        ChatMap.this.chan.setText(customPopup.getJeuxVideo().getText());
                        UserAccess.user.setChannel(customPopup.getJeuxVideo().getText()+"");
                        ChatMap.this.ll.removeAllViewsInLayout();
                        triggerMSGOtherChan();
                    }
                }
                customPopup.dismiss();
            }
        });

        customPopup.getRencontre().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(UserAccess.user.getChannel().equals("Général")){
                    ChatMap.this.chan.setText(customPopup.getRencontre().getText());
                    UserAccess.user.setChannel(customPopup.getRencontre().getText()+"");
                    ChatMap.this.ll.removeAllViewsInLayout();
                    triggerMSG();
                } else {
                    if(!UserAccess.user.getChannel().equals("Rencontre")){
                        ChatMap.this.chanBefore = UserAccess.user.getChannel();
                        ChatMap.this.chan.setText(customPopup.getRencontre().getText());
                        UserAccess.user.setChannel(customPopup.getRencontre().getText()+"");
                        ChatMap.this.ll.removeAllViewsInLayout();
                        triggerMSGOtherChan();
                    }
                }
                customPopup.dismiss();
            }
        });

        customPopup.getGeneral().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(!UserAccess.user.getChannel().equals("Général")){
                    ChatMap.this.chan.setText(customPopup.getGeneral().getText());
                    UserAccess.user.setChannel(customPopup.getGeneral().getText()+"");
                    ChatMap.this.ll.removeAllViewsInLayout();
                    triggerMSG();
                }
                customPopup.dismiss();
            }
        });
    }

    /**
     * is a trigger for the General channel is call when you want to change a channel or when you want to go in general channel
     */
    public void triggerMSG(){
        //this.fStore.collection("messages").orderBy("dateCreation");
        System.out.println((registration == null)+" test encore");
        if(registration == null) {
            registration = this.fStore.collection("messagesHub").whereGreaterThanOrEqualTo("dateCreation", Calendar.getInstance().getTime()).addSnapshotListener(new EventListener<QuerySnapshot>() {
                @Override
                public void onEvent(@Nullable QuerySnapshot snapshots,
                                    @Nullable FirebaseFirestoreException e) {

                    if (e != null) {
                        Log.w(TAG, "listen:error", e);
                        return;
                    }


                    for (DocumentChange dc : snapshots.getDocumentChanges()) {
                        if (dc.getType() == DocumentChange.Type.ADDED) {
                            if (ChatMap.this.location.equals(dc.getDocument().get("city").toString())) {
                                String pseudo = dc.getDocument().get("pseudo").toString();
                                String mess = dc.getDocument().get("message").toString();
                                TextView t = new TextView((ChatMap.this));
                                System.out.println(pseudo + " : " + mess);
                                t.setText(pseudo + " : " + mess);
                                ChatMap.this.ll.addView(t);
                            }
                        }
                    }

                }
            });
        } else {
            if(!UserAccess.user.getChannel().equals("Général")){
                registration.remove();
                registration = null;
                triggerMSGOtherChan();
            }
        }
    }

    /**
     * Trigger for the other channel is call when you want change channel
     */
    public void triggerMSGOtherChan(){
        //this.fStore.collection("messages").orderBy("dateCreation");
        System.out.println((registration == null)+" test encore");
        if(registration == null) {
            registration = this.fStore.collection("messagesHub").orderBy("dateCreation").addSnapshotListener(new EventListener<QuerySnapshot>() {
                @Override
                public void onEvent(@Nullable QuerySnapshot snapshots,
                                    @Nullable FirebaseFirestoreException e) {

                    if (e != null) {
                        Log.w(TAG, "listen:error", e);
                        return;
                    }


                    for (DocumentChange dc : snapshots.getDocumentChanges()) {
                        if (ChatMap.this.location.equals(dc.getDocument().get("city").toString()) && dc.getDocument().get("channel").toString().equals(UserAccess.user.getChannel())) {
                            if (dc.getType() == DocumentChange.Type.ADDED) {
                                String pseudo = dc.getDocument().get("pseudo").toString();
                                String mess = dc.getDocument().get("message").toString();
                                TextView t = new TextView((ChatMap.this));
                                System.out.println(pseudo + " : " + mess);
                                t.setText(pseudo + " : " + mess);
                                ChatMap.this.ll.addView(t);
                            }
                        }
                    }

                }
            });
        } else {

            if(UserAccess.user.getChannel().equals("Général")){
                registration.remove();
                registration = null;
                triggerMSG();
            } else {
                if(!this.chanBefore.equals(UserAccess.user.getChannel()) ){
                    this.chanBefore = UserAccess.user.getChannel();
                    registration.remove();
                    registration = null;
                    triggerMSGOtherChan();
                }

            }
        }
    }

    public void viewAccount( View v){
        startActivity(new Intent(getApplicationContext(), com.example.foundaroundme.EditProfileActivity.class));
    }

    public void logout(View view) {
        FirebaseAuth.getInstance().signOut();//logout
        startActivity(new Intent(getApplicationContext(),LoginActivity.class));
        finish();
    }



}
