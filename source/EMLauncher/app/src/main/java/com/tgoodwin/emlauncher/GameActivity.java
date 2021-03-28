package com.tgoodwin.emlauncher;

import androidx.appcompat.app.ActionBar;
import androidx.appcompat.app.AppCompatActivity;

import android.content.ComponentName;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.widget.AdapterView;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.TextView;

import com.google.gson.Gson;

// The fullscreen view for a selected game from our list
// This presents 1 or more "system" options to choose from but this is driven by the data
// and so could be anything - you could use the "games" in the list as folders and have these
// "systems" represent whatever you want, as they can all show specific labels, icons, and
// "screenshots"
public class GameActivity extends AppCompatActivity {
    private static final int INPUT_A_BUTTON = 189;
    private static final int INPUT_B_BUTTON = 190;

    // Use the AVD "Directional pad" left button to go back
    // or "Directional pad" select button to advance
    private static final int INPUT_DEBUG_BACK = 21;
    private static final int INPUT_DEBUG_SELECT = 23;

    // Selection defaults
    public static final int SELECTION_BLANK = -1;
    public static final int SELECTION_DEFAULT = 0;

    public static final String RETROARCH_PACKAGE = "com.retroarch.ra32";
    private static final String RETROARCH_ACTIVITY = "com.retroarch.browser.retroactivity.RetroActivityFuture";
    private static final String RETROARCH_CONFIG = "/mnt/sdcard/Android/data/com.retroarch.ra32/files/retroarch.cfg";
    private static final String RETROARCH_IME = "com.android.inputmethod.latin/.LatinIME";
    private static final String RETROARCH_PARAM_CORE = "LIBRETRO";
    private static final String RETROARCH_PARAM_ROM = "ROM";
    private static final String RETROARCH_PARAM_CONFIG = "CONFIGFILE";
    private static final String RETROARCH_PARAM_IME = "IME";

    private GridView simpleGrid;
    private GameSystem[] systems;

    private int gameIndex;

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

        setContentView(R.layout.activity_game);

        // Get the index of the game selected from the extra parameters of the intent when it was
        // launched - this is so we can go back to the same position in the list (more or less)
        gameIndex = getIntent().getIntExtra(ListActivity.LIST_PARAM_SELECTED, ListActivity.DEFAULT_GAME_INDEX);

        // Get and set the game name, does not change based on currently selected system
        String gameName = getIntent().getStringExtra(ListActivity.GAME_PARAM_NAME);
        TextView text = (TextView) findViewById(R.id.game_name);
        text.setText(gameName);

        // Collection of labels and paths for images to use when building the list of choices
        // and switching out screenshots based on the current choice
        String systemsJson = getIntent().getStringExtra(ListActivity.GAME_PARAM_SYSTEMS);
        systems = (new Gson()).fromJson(systemsJson, GameSystem[].class);

        // Get the screenshot view and pass it through, with the above systems data collection,
        // so the GameSystemAdapter can drive what's presented to the user based on the current
        // selection
        ImageView screenshotView = (ImageView) findViewById(R.id.screenshot);
        GameSystemAdapter gameSystemAdapter = new GameSystemAdapter(getApplicationContext(), systems, screenshotView);

        simpleGrid = (GridView) findViewById(R.id.gridView);
        simpleGrid.setAdapter(gameSystemAdapter);

        simpleGrid.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                gameSystemAdapter.newItemSelected(position);
            }

            @Override
            public void onNothingSelected (AdapterView<?> parent) {
                gameSystemAdapter.newItemSelected(SELECTION_BLANK);
            }
        });

        // Set the initial selection, causes various GUI elements to be instantiated and sensible
        // defaults set - i.e. the first element becomes the selected element, and the hilight to
        // show this to the user is set up properly
        gameSystemAdapter.newItemSelected(SELECTION_DEFAULT);
    }

    @Override
    public boolean dispatchKeyEvent(KeyEvent event) {
        if (event.getAction() != KeyEvent.ACTION_UP) {
            return super.dispatchKeyEvent(event);
        }

        int keyCode = event.getKeyCode();
        Log.d("keyCode: ", String.valueOf(keyCode));

        // Launch the given ROM with the given core
        // Passes through all the necessary info to RetroArch
        if (keyCode == INPUT_A_BUTTON || keyCode == INPUT_DEBUG_SELECT) {
            GameSystemAdapter adapter = (GameSystemAdapter)simpleGrid.getAdapter();

            GameSystem system = null;
            int systemIndex = adapter.getSetectedSystemIndex();
            if (systemIndex > -1 && systemIndex < systems.length) {
                system = systems[systemIndex];
            }

            if (system != null) {
                Intent launchIntent = new Intent();
                launchIntent.setComponent(new ComponentName(RETROARCH_PACKAGE, RETROARCH_ACTIVITY));
                launchIntent.putExtra(RETROARCH_PARAM_CORE, system.core_path);
                launchIntent.putExtra(RETROARCH_PARAM_ROM, system.path);
                launchIntent.putExtra(RETROARCH_PARAM_CONFIG, RETROARCH_CONFIG);
                launchIntent.putExtra(RETROARCH_PARAM_IME, RETROARCH_IME);
                startActivity(launchIntent);
            }

        // Go back to the games list
        } else if (keyCode == INPUT_B_BUTTON || keyCode == INPUT_DEBUG_BACK) {
            Intent listIntent = new Intent(this, ListActivity.class);
            listIntent.putExtra(ListActivity.LIST_PARAM_SELECTED, gameIndex);
            startActivity(listIntent);
        }

        return super.dispatchKeyEvent(event);
    }
}