package com.example.foundaroundme;

import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.QuerySnapshot;

/**
 * @version 1.0
 */
public class LoginActivity extends AppCompatActivity {

    EditText mEmail,mPassword;
    Button mLoginBtn;
    TextView mCreateBtn;
    FirebaseAuth fAuth;
    FirebaseFirestore fStore;

    /**
     * onCreate initialized the attribute of the class and draw the interface
     * @param savedInstanceState
     */
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getSupportActionBar().hide();
        setContentView(R.layout.activity_login);

        mEmail = findViewById(R.id.txtEmail);
        mPassword = findViewById(R.id.txtPasword);
        fAuth = FirebaseAuth.getInstance();
        mLoginBtn = findViewById(R.id.btnConnexion);
        mCreateBtn = findViewById(R.id.txtDejaCreer);
        UserAccess.user = new User();
    }

    /**
     * do a verification if the editText email or password is not empty and after that research in firecloud fi your email and password is right if is right you can go in the chat else you retry.
     * @param v
     */
    public void connexion(View v){
        String email = mEmail.getText().toString().trim();
        String testPassword = mPassword.getText().toString().trim();
        String password = com.example.foundaroundme.CryptSHA.toSHA256(testPassword);
        TextView t = findViewById(R.id.txtTitleCreer);
        Boolean acces = true;
        if(TextUtils.isEmpty(email)){
            mEmail.setError("Votre adresse email est requis.");
            acces = false;
        }

        if(TextUtils.isEmpty(testPassword)){
            mPassword.setError("Votre mot de passe est requis.");
            acces = false;
        }

        if(acces){
            fStore = FirebaseFirestore.getInstance();

            fStore.collection("users").whereEqualTo("email",email).get().addOnCompleteListener(new OnCompleteListener<QuerySnapshot>() {
                @Override
                public  synchronized void onComplete(@NonNull Task<QuerySnapshot> task) {
                    if(task.isSuccessful()){
                        QuerySnapshot snapshot = task.getResult();
                        for(DocumentSnapshot d : snapshot.getDocuments()){
                            if(d.get("password").equals(password)) {
                                startActivity(new Intent(getApplicationContext(), com.example.foundaroundme.ChatMap.class));

                                //  User save data
                                UserAccess.user.setEmail(d.get("email").toString());
                                UserAccess.user.setPseudo(d.get("pseudo").toString());
                                UserAccess.user.setFirstName(d.get("firstName").toString());
                                UserAccess.user.setLastName(d.get("lastName").toString());
                                UserAccess.user.setPassword(d.get("password").toString());

                                //  Trouver une solution pour récupérer Date UserAccess.user.setDateCreation(d.get("dateCreation"));

                            } else {
                                mPassword.setError("Mot de passe ou login incorect");
                            }
                        }
                        if(snapshot.getDocuments().size() == 0){
                            Log.d("TAG", "Mot de passe ou login incorrect", task.getException());
                            mPassword.setError("Mot de passe ou login incorect");
                        }
                    } else {
                        Log.d("TAG", "Mot de passe ou login incorrect", task.getException());
                        mPassword.setError("Mot de passe ou login incorect");
                    }
                }
            });
        }
    }

    /**
     * for the user to create a account
     * @param v
     */
    public void createAccount(View v){
        startActivity(new Intent(getApplicationContext(), com.example.foundaroundme.RegisterActivity.class));
    }







}
