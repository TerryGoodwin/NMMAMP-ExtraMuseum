// Namco Musem - My Arcade Mini Player - Extra Musem
// Version 0.1.2.0
// Copyright 2021 Terry Goodwin

package com.tgoodwin.emlauncher;

import androidx.appcompat.app.ActionBar;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;

public class FullscreenActivity extends AppCompatActivity {
    private static final int INPUT_A_BUTTON = 189;
    private static final int INPUT_B_BUTTON = 190;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_fullscreen);

        ActionBar actionBar = getSupportActionBar();
        if (actionBar != null) {
            actionBar.hide();
        }
    }

    @Override
    public boolean dispatchKeyEvent(KeyEvent event) {
        if (event.getAction() != KeyEvent.ACTION_UP) {
            return super.dispatchKeyEvent(event);
        }

        int keyCode = event.getKeyCode();
        Log.d("keyCode: ", String.valueOf(keyCode));
        if (keyCode == INPUT_A_BUTTON) { // A button
            Intent launchIntent = getPackageManager().getLaunchIntentForPackage("com.cx.gamelaunch");
            if (launchIntent != null) { // Check package is valid...
                startActivity(launchIntent);
            }
        } else if (keyCode == INPUT_B_BUTTON) { // B button
            Intent launchIntent = getPackageManager().getLaunchIntentForPackage("com.retroarch.ra32");
            if (launchIntent != null) { // Check package is valid...
                startActivity(launchIntent);
            }
        }

        return super.dispatchKeyEvent(event);
    }
}