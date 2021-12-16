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
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.QuerySnapshot;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**

 */
public class RegisterActivity extends AppCompatActivity {
    public static final String TAG = "TAG";
    EditText mFullName, mEmail, mPassword, mConfirmPassword, mPseudo, mFirstName;
    Button mRegisterBtn;
    TextView mLoginBtn;
    FirebaseAuth fAuth;
    FirebaseFirestore fStore;
    private boolean acces;

    /**
     * Initialize the view and the attribut of the class
     * @param savedInstanceState
     */
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getSupportActionBar().hide();
        setContentView(R.layout.activity_register);

        mFullName   = findViewById(R.id.txtNom);
        mFirstName = findViewById(R.id.txtPrenom);
        mEmail      = findViewById(R.id.txtEmail);
        mPassword   = findViewById(R.id.txtPasword);
        mConfirmPassword = findViewById(R.id.txtConfirmPassword);
        mPseudo      = findViewById(R.id.txtPseudo);
        mRegisterBtn= findViewById(R.id.btnEnregistrer);
        mLoginBtn   = findViewById(R.id.txtDejaCreer);
    }

    /**
     * create a account for the user. Beffore that is verif if all editText was not empty and the the email don't exist after that your account is created and you return in the login activity
     * @param v
     */
    public void register(View v){
        String email = mEmail.getText().toString().trim();

        String testPassword = mPassword.getText().toString().trim();
        String password = com.example.foundaroundme.CryptSHA.toSHA256(testPassword);
        String passwordConfirm = mConfirmPassword.getText().toString().trim();
        String fullName = mFullName.getText().toString();
        String firstName = mFirstName.getText().toString();
        String pseudo    = mPseudo.getText().toString();
        acces = true;
        fStore = FirebaseFirestore.getInstance();

        if(TextUtils.isEmpty(email)){
            mEmail.setError("Email est requis.");
            acces = false;
        }

        if(TextUtils.isEmpty(fullName)){
            mFullName.setError("Confirmation du pseudo est requise.");
            acces = false;
        }

        if(TextUtils.isEmpty(firstName)){
            mFirstName.setError("Confirmation du nom est requise.");
            acces = false;
        }

        if(TextUtils.isEmpty(pseudo)){
            mPseudo.setError("Confirmation du pseudo est requise.");
            acces = false;
        }

        if(TextUtils.isEmpty(password)){
            mPassword.setError("Mot de passe est requis.");
            acces = false;
        }

        if(TextUtils.isEmpty(passwordConfirm)){
            mConfirmPassword.setError("Confirmation de mot de passe est requise.");
            acces = false;
        }

        if(password.length() < 6){
            mPassword.setError("Le mot de passe doit contenir> = 6 caractères");
            acces = false;
        }

        if(acces && !(mPassword.getText().toString().contentEquals(passwordConfirm))){
            mConfirmPassword.setError("Les 2 mots de passe ne sont pas identiques");
            acces = false;
        }


        // register the user in firebase
        if(acces){
            Calendar current = Calendar.getInstance();
            Date dateCreation = current.getTime();

            Map<String, Object> users = new HashMap<>();
            users.put("lastName", fullName);
            users.put("firstName", firstName);
            users.put("email", email);
            users.put("pseudo", pseudo);
            users.put("password",password);
            users.put("dateCreation", dateCreation);

            fStore.collection("users").whereEqualTo("email",email).get().addOnCompleteListener(new OnCompleteListener<QuerySnapshot>() {
                @Override
                public  synchronized void onComplete(@NonNull Task<QuerySnapshot> task) {
                    if(task.isComplete()) {

                        QuerySnapshot snapshot = task.getResult();
                        if(snapshot.getDocuments().size() == 0){
                            RegisterActivity.this.fStore.collection("users").document().set(users).addOnSuccessListener(new OnSuccessListener<Void>() {
                                @Override
                                public void onSuccess(Void aVoid) {
                                    Log.d(TAG, "DocumentSnapshot successfully written!");
                                    startActivity(new Intent(getApplicationContext(),LoginActivity.class));
                                }
                            }).addOnFailureListener(new OnFailureListener() {
                                @Override
                                public void onFailure(@NonNull Exception e) {
                                    Log.w(TAG, "Error writing document", e);
                                }
                            });
                        } else {
                            mEmail.setError("Email exieste déja.");
                        }
                    }
                }
            });
        }
    }

    /**
     * return to the login activity
     * @param v
     */
    public void returnLogin(View v){
        startActivity(new Intent(getApplicationContext(),LoginActivity.class));

    }
}