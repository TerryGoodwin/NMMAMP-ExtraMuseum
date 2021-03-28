package com.tgoodwin.emlauncher;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.appcompat.content.res.AppCompatResources;

import java.io.File;
import java.util.Arrays;

public class GameSystemAdapter extends BaseAdapter {
    private Context context;
    private GameSystem items[];
    private ImageView screenshotView;

    private View views[];

    private LayoutInflater inflter;

    private int selectedSystem;

    public GameSystemAdapter(Context applicationContext, GameSystem[] itemsIn, ImageView screenshotIn) {
        this.context = applicationContext;
        this.items = itemsIn;
        this.screenshotView = screenshotIn;

        inflter = (LayoutInflater.from(applicationContext));
        selectedSystem = -1;

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
        if (views[i] != null) {
            view = views[i];
            return view;
        }

        view = inflter.inflate(R.layout.activity_gridview_systems, null);
        views[i] = view;

        Drawable systemIcon = items[i].drawIcon;
        if (systemIcon == null) {
            File thumbFile = new File(items[i].icon);

            if (thumbFile.exists()) {
                systemIcon = Drawable.createFromPath(items[i].icon);
            }

            if (systemIcon == null) {
                systemIcon = AppCompatResources.getDrawable(context, R.drawable.system_icon_default);
            }

            if (systemIcon != null) {
                items[i].drawIcon = systemIcon;
            }
        }

        if (systemIcon != null) {
            ImageView icon = (ImageView) view.findViewById(R.id.icon);
            icon.setImageDrawable(systemIcon);
        }

        TextView text = (TextView) view.findViewById(R.id.name);
        text.setText(items[i].label);

        ImageView hilight = (ImageView) view.findViewById(R.id.hilight_left);
        if (i != 0) {
            hilight.setVisibility(view.INVISIBLE);
        }
        hilight = (ImageView) view.findViewById(R.id.hilight_right);
        if (i != 0) {
            hilight.setVisibility(view.INVISIBLE);
        }

        return view;
    }

    public void newItemSelected(int newSelection) {
        if (selectedSystem == newSelection) {
            return;
        }

        View view = null;
        ImageView hilight = null;
        if (selectedSystem > -1 && selectedSystem < views.length) {
            view = views[selectedSystem];
            if (view != null) {
                hilight = (ImageView) view.findViewById(R.id.hilight_left);
                if (hilight != null) {
                    hilight.setVisibility(view.INVISIBLE);
                }
                hilight = (ImageView) view.findViewById(R.id.hilight_right);
                if (hilight != null) {
                    hilight.setVisibility(view.INVISIBLE);
                }
            }
        }
        if (newSelection >= views.length) {
            return;
        }

        selectedSystem = newSelection;

        view = views[selectedSystem];
        if (view == null) {
            view = getView(selectedSystem, view, null);
        }

        if (view != null) {
            hilight = (ImageView) view.findViewById(R.id.hilight_left);
            if (hilight != null) {
                hilight.setVisibility(view.VISIBLE);
            }
            hilight = (ImageView) view.findViewById(R.id.hilight_right);
            if (hilight != null) {
                hilight.setVisibility(view.VISIBLE);
            }
        }

        GameSystem system = items[selectedSystem];
        Drawable screenshot = system.drawScreenshot;
        if (screenshot == null) {
            File shotFile = new File(system.screenshot);

            if (shotFile.exists()) {
                screenshot = Drawable.createFromPath(system.screenshot);
            }

            if (screenshot == null) {
                screenshot = AppCompatResources.getDrawable(context, R.drawable.screenshot_default);
            }

            if (screenshot != null) {
                system.drawScreenshot = screenshot;
            }
        }

        if (screenshot != null) {
            screenshotView.setImageDrawable(screenshot);
        }
    }

    public int getSetectedSystemIndex() {
        return selectedSystem;
    }
}
