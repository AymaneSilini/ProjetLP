package com.example.foundaroundme;

import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.QuerySnapshot;

public class BDD {

    public static String id ="";

    public synchronized static String getId(String email){
        if(email != null && email != "" ) {
            FirebaseFirestore fStore = FirebaseFirestore.getInstance();
            while(fStore.collection("users").whereEqualTo("email",email).get().isComplete())
            {

            }
            QuerySnapshot snapshot = (QuerySnapshot) fStore.collection("users").whereEqualTo("email",email).get().getResult().getDocuments().iterator();
            for(DocumentSnapshot d : snapshot.getDocuments()){
                System.out.println(d.getId()+"hahahahahahahahhahaha");
                id = d.getId();
            }
        }

        System.out.println(id+" test hahahahahahahahhahaha");
        return id;
    }
}
