package com.example.foundaroundme;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.FirebaseFirestore;

import java.util.HashMap;
import java.util.Map;

public class EditProfileActivity extends AppCompatActivity {

    public static final String TAG = "TAG";
    EditText profileNom,profilePrenom,profileEmail,profilePseudo;
    Button saveBtn;
    FirebaseAuth fAuth;
    FirebaseFirestore fStore;
    FirebaseUser user;


    @Override
    protected void onCreate(Bundle savedInstanceState) {

        getSupportActionBar().hide();
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_profile);

        final String fullName =  UserAccess.user.getFirstName();
        String email =  UserAccess.user.getEmail();
        String firstName =  UserAccess.user.getLastName();
        String pseudo =  UserAccess.user.getPseudo();

        fAuth = FirebaseAuth.getInstance();
        fStore = FirebaseFirestore.getInstance();
        user = fAuth.getCurrentUser();

        profileNom = findViewById(R.id.profileNom);
        profilePrenom = findViewById(R.id.profilePrenom);
        profileEmail = findViewById(R.id.profileEmail);
        profilePseudo = findViewById(R.id.profilePseudo);
        profileEmail.setText(email);
        profileNom.setText(firstName);
        profilePrenom.setText(fullName);
        profilePseudo.setText(pseudo);
    }

    public void retourMap(View v){
        startActivity(new Intent(getApplicationContext(), com.example.foundaroundme.ChatMap.class));
    }

    public void logout(View view) {
        FirebaseAuth.getInstance().signOut();//logout
        startActivity(new Intent(getApplicationContext(),LoginActivity.class));
        finish();
    }


}
