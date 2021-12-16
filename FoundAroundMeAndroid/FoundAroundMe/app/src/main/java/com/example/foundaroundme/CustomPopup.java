package com.example.foundaroundme;

import android.app.Dialog;
import android.content.Context;
import android.widget.Button;

import androidx.annotation.NonNull;

public class CustomPopup extends Dialog {

    private Button general, transport, rencontre, restauration, jeuxvideo, culture;
    public CustomPopup(@NonNull Context context) {
        super(context);
        setContentView(R.layout.pop_up_layout);
        this.general = findViewById(R.id.btnGeneral);
        this.transport = findViewById(R.id.btnTransport);
        this.rencontre = findViewById(R.id.btnRencontre);
        this.restauration = findViewById(R.id.btnRestauration);
        this.jeuxvideo = findViewById(R.id.btnJeuxVideo);
        this.culture = findViewById(R.id.btnCulture);
        this.show();
    }

    public Button getTransport() {   return transport; }

    public Button getRestauration() {
        return restauration;
    }

    public Button getGeneral() {
        return general;
    }

    public Button getCulture() {
        return culture;
    }

    public Button getRencontre() {
        return rencontre;
    }

    public Button getJeuxVideo() {return jeuxvideo;}
}
