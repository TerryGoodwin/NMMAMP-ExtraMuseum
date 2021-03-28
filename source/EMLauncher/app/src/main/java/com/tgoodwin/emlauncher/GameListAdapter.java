package com.tgoodwin.emlauncher;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;

import androidx.appcompat.content.res.AppCompatResources;

import java.io.File;
import java.util.Arrays;

public class GameListAdapter extends BaseAdapter {
    private Context context;

    private View views[];
    private GameItem items[];

    private LayoutInflater inflter;

    private int selectedGame;
    private int startSelectedGame;

    public GameListAdapter(Context applicationContext, GameItem[] itemsIn, int selectedGameIn) {
        this.context = applicationContext;
        this.items = itemsIn;
        inflter = (LayoutInflater.from(applicationContext));
        selectedGame = -1;
        startSelectedGame = selectedGameIn;

        int arrayLength = itemsIn.length;
        views = new View[arrayLength];
        Arrays.fill(views, 0, arrayLength-1, null);
    }
    @Override
    public int getCount() {
        return items.length;
    }
    @Override
    public Object getItem(int i) {
        return views[i];
    }
    @Override
    public long getItemId(int i) {
        return 0;
    }
    @Override
    public View getView(int i, View view, ViewGroup viewGroup) {
        while (i >= items.length) {
            i = i-items.length;
        }

        if (views[i] != null) {
            view = views[i];
            return view;
        }

        view = inflter.inflate(R.layout.activity_gridview, null);
        views[i] = view;

        Drawable thumbnail = null;
        GameItem item = items[i];

        if (item != null) {
            thumbnail = item.drawThumbnail;
            if (thumbnail == null) {
                File thumbFile = new File(item.thumbnail);

                if (thumbFile.exists()) {
                    thumbnail = Drawable.createFromPath(item.thumbnail);
                }

                if (thumbnail == null) {
                    if (item.thumbnail.isEmpty()) {
                        thumbnail = AppCompatResources.getDrawable(context, R.drawable.thumbnail_blank);
                    } else {
                        thumbnail = AppCompatResources.getDrawable(context, R.drawable.thumbnail_default);
                    }
                }

                if (thumbnail != null) {
                    item.drawThumbnail = thumbnail;
                }
            }
        }

        if (thumbnail != null) {
            ImageView icon = (ImageView) view.findViewById(R.id.icon);
            icon.setImageDrawable(thumbnail);
        }

        ImageView hilight = (ImageView) view.findViewById(R.id.hilight);
        if (i != startSelectedGame) {
            hilight.setVisibility(view.INVISIBLE);
        }

        return view;
    }

    public void newItemSelected(int newSelection) {
        if (selectedGame == newSelection) {
            return;
        }

        View view = null;
        ImageView hilight = null;
        if (selectedGame > -1 && selectedGame < views.length) {
            view = views[selectedGame];
            if (view != null) {
                hilight = (ImageView) view.findViewById(R.id.hilight);
                hilight.setVisibility(view.INVISIBLE);
            }
        }
        if (newSelection >= views.length) {
            return;
        }

        selectedGame = newSelection;

        view = views[selectedGame];
        if (view == null) {
            view = getView(selectedGame, view, null);
        }

        if (view != null) {
            hilight = (ImageView) view.findViewById(R.id.hilight);
            hilight.setVisibility(view.VISIBLE);
        }
    }

    public int getSelectedGameIndex() {
        return selectedGame;
    }
}
