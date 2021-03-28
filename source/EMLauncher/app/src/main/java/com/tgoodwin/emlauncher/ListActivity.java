package com.tgoodwin.emlauncher;

import androidx.appcompat.app.ActionBar;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.widget.AdapterView;
import android.widget.GridView;

import com.google.gson.Gson;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class ListActivity extends AppCompatActivity {
    private static final int INPUT_A_BUTTON = 189;
    private static final int INPUT_B_BUTTON = 190;

    private static final int INPUT_DEBUG_SELECT = 23;

    private static final String GAME_LIST_NAME = "gamelist";
    private static final String IMAGE_EXTENSION = ".png";
    private static final String JSON_EXTENSION = ".json";

    public static final int DEFAULT_GAME_INDEX = 0;

    public static final String LIST_PARAM_SELECTED = "selected";

    public static final String GAME_PARAM_NAME = "name";
    public static final String GAME_PARAM_SYSTEMS = "systems";

    private static final String GAMELIST_JSON_CHARSET = "UTF-8";
    private static final String GAMELIST_JSON_ITEMS = "items";
    private static final String GAMELIST_JSON_LABEL = "label";
    private static final String GAMELIST_JSON_THUMBNAIL = "thumbnail";
    private static final String GAMELIST_JSON_SYSTEMS = "systems";
    private static final String GAMELIST_JSON_PATH = "path";
    private static final String GAMELIST_JSON_CORE_PATH = "core_path";
    private static final String GAMELIST_JSON_ICON = "icon";
    private static final String GAMELIST_JSON_SNAP = "snap";

    private static final String DIRECTORY_THUMBNAILS = "thumbnails";
    private static final String DIRECTORY_SCREENSHOTS = "screenshots";
    private static final String DIRECTORY_SYSTEMS = "systems";

    private static final String RESOURCE_TYPE_RAW = "raw";

    private static final int RESOURCE_COPY_BUFFER_SIZE = 1024;

    private static final boolean DEBUG_COPY_RAW_RESOURCES = false;
    private static final boolean DEBUG_FORCE_COPY_FILES = false;
    private static final String[] DEBUG_COPY_SYSTEMS_ARRAY = new String[]{
            "system_2600", "system_5200", "system_7800", "system_arc", "system_fam", "system_gb",
            "system_gbc", "system_gen", "system_gg", "system_md", "system_nes", "system_ngpc",
            "system_pce", "system_sg1k", "system_sms", "system_tg16"
    };

    GridView simpleGrid = null;
    GameItem games[] = null;

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

        setContentView(R.layout.activity_list);

        // Parse the JSON game list and build up an array of content
        parseGameList();

        // DEBUG - Copy system icons from raw resources into place in /data
        if (DEBUG_COPY_RAW_RESOURCES == true) {
            for (int sys = 0; sys < DEBUG_COPY_SYSTEMS_ARRAY.length; sys++) {
                copyResources(DEBUG_COPY_SYSTEMS_ARRAY[sys], IMAGE_EXTENSION, DIRECTORY_SYSTEMS);
            }
        }

        // Get the last selected game index, if it's been set, so we can jump directly to where
        // we were
        int gameIndex = DEFAULT_GAME_INDEX;
        if (getIntent().hasExtra(LIST_PARAM_SELECTED)) {
            gameIndex = getIntent().getIntExtra(LIST_PARAM_SELECTED, DEFAULT_GAME_INDEX);
        }

        // Pass all the games data through to the list adapter to display it all to the user
        GameListAdapter gameListAdapter = new GameListAdapter(getApplicationContext(), games, gameIndex);

        simpleGrid = (GridView) findViewById(R.id.gridView);
        simpleGrid.setAdapter(gameListAdapter);

        simpleGrid.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                gameListAdapter.newItemSelected(position);
            }

            @Override
            public void onNothingSelected (AdapterView<?> parent) {
                gameListAdapter.newItemSelected(GameActivity.SELECTION_BLANK);
            }
        });

        // Jump to the end of the list and then back to the current index to force things to be
        // loaded and set up
        simpleGrid.setSelection(games.length-1);
        gameListAdapter.notifyDataSetChanged();
        simpleGrid.setSelection(gameIndex);
        gameListAdapter.notifyDataSetChanged();

        // Set the initial selection, causes various GUI elements to be instantiated and sensible
        // defaults set - i.e. the first element becomes the selected element, and the hilight to
        // show this to the user is set up properly
        gameListAdapter.newItemSelected(gameIndex);
    }

    @Override
    public boolean dispatchKeyEvent(KeyEvent event) {
        if (event.getAction() != KeyEvent.ACTION_UP) {
            return super.dispatchKeyEvent(event);
        }

        int keyCode = event.getKeyCode();
        Log.d("keyCode: ", String.valueOf(keyCode));

        // Go to the GameActivity for the currently selected game
        if (keyCode == INPUT_A_BUTTON || keyCode == INPUT_DEBUG_SELECT) {
            // Get the index of the currently selected game from the list adapter
            // so we can get together all the data that the GameActivity needs to display
            // further options to the user
            GameListAdapter adapter = (GameListAdapter)simpleGrid.getAdapter();
            int gameIndex = adapter.getSelectedGameIndex();
            GameItem game = games[gameIndex];

            if (game != null) {
                // JSONify our "systems" data so we can pass it all through to the GameActivity.
                // This includes labels and paths to images, cores, and ROMs
                String systemsJson = (new Gson()).toJson(game.systems);

                Intent gameIntent = new Intent(this, GameActivity.class);
                gameIntent.putExtra(GAME_PARAM_NAME, game.label);
                gameIntent.putExtra(GAME_PARAM_SYSTEMS, systemsJson);
                gameIntent.putExtra(LIST_PARAM_SELECTED, gameIndex);
                startActivity(gameIntent);
            }

        // Go back to the first menu, to launch the stock frontend or RetroArch
        } else if (keyCode == INPUT_B_BUTTON) {
            Intent menuIntent = new Intent(this, FullscreenActivity.class);
            startActivity(menuIntent);
        }

        return super.dispatchKeyEvent(event);
    }

    private void parseGameList() {
        // Copy the built-in games list from the raw resources directory to the /data directory
        // of this app, so that we have SOMETHING to load and present to the user.
        // Unless a debug flag is set, this will not overwrite the existing data.
        copyResources(R.raw.gamelist, JSON_EXTENSION, "");

        // Read the gamelist.json file as a string, ready to parse as JSON
        String json = null;
        try {
            InputStream is = new FileInputStream(
                    this.getApplicationInfo().dataDir+File.separator+GAME_LIST_NAME+JSON_EXTENSION);
            int size = is.available();
            byte[] buffer = new byte[size];
            is.read(buffer);
            is.close();
            json = new String(buffer, GAMELIST_JSON_CHARSET);
        } catch (IOException ex) {
            ex.printStackTrace();
            return;
        }

        // Make some JSON objects out of our gamelist string and traverse it to get all the
        // data we're looking for
        try {
            JSONObject obj = new JSONObject(json);
            JSONArray itemsArray = obj.getJSONArray(GAMELIST_JSON_ITEMS);
            int numItems = itemsArray.length();

            games = new GameItem[numItems];

            GameItem item = null;
            GameSystem system = null;
            int numSystems = 0;
            JSONObject jsonItem = null;
            JSONArray systemsArray = null;
            for (int i = 0; i < numItems; i++) {

                // Get all the data for each individual item in the list...
                jsonItem = itemsArray.getJSONObject(i);

                item = new GameItem();
                item.label = "";
                item.thumbnail = "";
                item.drawThumbnail = null;

                if (jsonItem.has(GAMELIST_JSON_LABEL)) {
                    item.label = jsonItem.getString(GAMELIST_JSON_LABEL);
                }
                if (jsonItem.has(GAMELIST_JSON_THUMBNAIL)) {
                    item.thumbnail = jsonItem.getString(GAMELIST_JSON_THUMBNAIL);

                    // If we have these thumbnails in our raw resources director, copy them into
                    // place in /data - saves us having to copy things over using ADB
                    if (DEBUG_COPY_RAW_RESOURCES == true) {
                        String filename = item.thumbnail.substring(item.thumbnail.lastIndexOf(File.separator) + 1);
                        filename = filename.substring(0, filename.lastIndexOf("."));
                        copyResources(filename, IMAGE_EXTENSION, DIRECTORY_THUMBNAILS);
                    }
                }

                if (jsonItem.has(GAMELIST_JSON_SYSTEMS)) {
                    systemsArray = jsonItem.getJSONArray(GAMELIST_JSON_SYSTEMS);
                } else {
                    systemsArray = new JSONArray();
                }
                numSystems = systemsArray.length();

                item.systems = new GameSystem[numSystems];

                // Get the data for each "system" for this item - this was conceived as being
                // different platforms (e.g. the Game Boy, Arcade, NES etc. versions of a game)
                // but could be adapted very easily into folders or something like this
                // - there's no limit placed on how man "systems" there can be, except memory...
                for (int j = 0; j < numSystems; j++) {
                    jsonItem = systemsArray.getJSONObject(j);

                    system = new GameSystem();

                    system.label = "";
                    system.path = "";
                    system.core_path = "";
                    system.icon = "";
                    system.screenshot = "";
                    system.drawIcon = null;
                    system.drawScreenshot = null;

                    if (jsonItem.has(GAMELIST_JSON_LABEL)) {
                        system.label = jsonItem.getString(GAMELIST_JSON_LABEL);
                    }
                    if (jsonItem.has(GAMELIST_JSON_PATH)) {
                        system.path = jsonItem.getString(GAMELIST_JSON_PATH);
                    }
                    if (jsonItem.has(GAMELIST_JSON_CORE_PATH)) {
                        system.core_path = jsonItem.getString(GAMELIST_JSON_CORE_PATH);
                    }
                    if (jsonItem.has(GAMELIST_JSON_ICON)) {
                        system.icon = jsonItem.getString(GAMELIST_JSON_ICON);
                    }
                    if (jsonItem.has(GAMELIST_JSON_SNAP)) {
                        system.screenshot = jsonItem.getString(GAMELIST_JSON_SNAP);

                        // If we have these screenshots in our raw resources director, copy them into
                        // place in /data - saves us having to copy things over using ADB
                        if (DEBUG_COPY_RAW_RESOURCES == true) {
                            String filename = system.screenshot.substring(system.screenshot.lastIndexOf("/") + 1);
                            filename = filename.substring(0, filename.lastIndexOf("."));
                            copyResources(filename, IMAGE_EXTENSION, DIRECTORY_SCREENSHOTS);
                        }
                    }

                    item.systems[j] = system;
                }

                games[i] = item;
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    private void copyResources(int resId, String extension, String subDir) {
        String filename = this.getResources().getResourceEntryName(resId);
        copyResources(filename, extension, subDir);
    }
    private void copyResources(String filename, String extension, String subDir) {
        int resId = this.getResources().getIdentifier(filename, RESOURCE_TYPE_RAW, this.getPackageName());
        if (resId == 0) {
            return; // ID invalid
        }

        InputStream in = this.getResources().openRawResource(resId);

        String directory = this.getApplicationInfo().dataDir;
        if (!subDir.isEmpty()) {
            directory += File.separator + subDir;
        }

        if (!subDir.isEmpty()) {
            File folder = new File(directory);
            boolean success = true;
            if (!folder.exists()) {
                success = folder.mkdir();
            }

            if (!success) {
                Log.i("List", "copyResources - couldn't make directory " + directory);
            }
        }

        filename += extension;

        if (DEBUG_FORCE_COPY_FILES == false) {
            String fullPath = directory+File.separator+filename;
            File destinationFile = new File(fullPath);
            if (destinationFile.exists()) {
                return;
            }
        }

        try {
            OutputStream out = new FileOutputStream(new File(directory, filename));
            byte[] buffer = new byte[RESOURCE_COPY_BUFFER_SIZE];
            int len;
            while((len = in.read(buffer, 0, buffer.length)) != -1){
                out.write(buffer, 0, len);
            }
            in.close();
            out.close();
        } catch (FileNotFoundException e) {
            Log.i("List", "copyResources - "+e.getMessage());
        } catch (IOException e) {
            Log.i("List", "copyResources - "+e.getMessage());
        }
    }


}