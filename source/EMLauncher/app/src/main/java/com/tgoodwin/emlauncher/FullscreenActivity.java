package com.tgoodwin.emlauncher;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;

import androidx.appcompat.app.ActionBar;
import androidx.appcompat.app.AppCompatActivity;

// The main Activity, simple static screen to chose:
// a) The original stock experience, untouched
// b) The "Extra Museum" - our data-driven list of games
// y) Launch RetroArch directly - separate app that must be installed!
public class FullscreenActivity extends AppCompatActivity {
    private static final int INPUT_A_BUTTON = 189;
    private static final int INPUT_B_BUTTON = 190;
    private static final int INPUT_Y_BUTTON = 191;

    // Use the AVD "Directional pad" select button to advance
    private static final int INPUT_DEBUG_SELECT = 23;

    private static final String GAMELAUNCH_PACKAGE = "com.cx.gamelaunch";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Hide the status bar
        View decorView = getWindow().getDecorView();
        int uiOptions = View.SYSTEM_UI_FLAG_FULLSCREEN;
        decorView.setSystemUiVisibility(uiOptions);

        // Hide the navigation bar
        ActionBar actionBar = getSupportActionBar();
        if (actionBar != null) {
            actionBar.hide();
        }

        setContentView(R.layout.activity_fullscreen);
    }

    @Override
    public boolean dispatchKeyEvent(KeyEvent event) {
        if (event.getAction() != KeyEvent.ACTION_UP) {
            return super.dispatchKeyEvent(event);
        }

        int keyCode = event.getKeyCode();
        Log.d("keyCode: ", String.valueOf(keyCode));

        // Launch the original, untouched frontend/experience
        if (keyCode == INPUT_A_BUTTON) {
            Intent launchIntent = getPackageManager().getLaunchIntentForPackage(GAMELAUNCH_PACKAGE);
            if (launchIntent != null) { // Check package is valid...
                startActivity(launchIntent);
            }

        // Move into the "Extra Museum" list of games
        } else if (keyCode == INPUT_B_BUTTON || keyCode == INPUT_DEBUG_SELECT) {
            Intent listIntent = new Intent(this, ListActivity.class);
            startActivity(listIntent);

        // Launch RetroArch - must have been installed! It is a separate app
        } else if (keyCode == INPUT_Y_BUTTON) { // Y button
            Intent launchIntent = getPackageManager().getLaunchIntentForPackage(GameActivity.RETROARCH_PACKAGE);
            if (launchIntent != null) { // Check package is valid...
                startActivity(launchIntent);
            }
        }

        return super.dispatchKeyEvent(event);
    }
}