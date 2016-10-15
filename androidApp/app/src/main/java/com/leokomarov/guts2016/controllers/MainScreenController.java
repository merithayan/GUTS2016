package com.leokomarov.guts2016.controllers;

import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.NonNull;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.ImageButton;
import android.widget.ImageView;

import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.location.LocationServices;
import com.leokomarov.guts2016.Direction;
import com.leokomarov.guts2016.MapStuff;
import com.leokomarov.guts2016.Position;
import com.leokomarov.guts2016.R;
import com.leokomarov.guts2016.SocketStuff;
import com.mapbox.mapboxsdk.geometry.LatLng;
import com.mapbox.mapboxsdk.maps.MapView;

import butterknife.BindView;
import butterknife.OnClick;

import static com.leokomarov.guts2016.Position.PERMISSION_ACCESS_COARSE_LOCATION;
import static com.leokomarov.guts2016.Position.PERMISSION_ACCESS_FINE_LOCATION;

public class MainScreenController extends ButterKnifeController {

    private SocketStuff socketStuff;
    public MapStuff mapStuff;
    private Position position;
    private Direction direction;

    public String username;
    public String id;

    private int maxHealth = 3;
    public int health;

    @BindView(R.id.mapview)
    public MapView mapView;

    @BindView(R.id.battery_frame)
    FrameLayout frameLayout;

    @BindView(R.id.fireButton)
    ImageButton fireImageButton;

    @BindView(R.id.powerUpButton)
    ImageButton powerUpImageButton;

    @OnClick(R.id.fireButton)
    void fireImageButtonClicked(){
        fireImageButton.setImageResource(R.drawable.fire_button_active);

        socketStuff.mSocket.emit("fire");

        final Handler handler = new Handler();
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                fireImageButton.setImageResource(R.drawable.fire_button);
            }
        }, 500);
    }

    @OnClick(R.id.powerUpButton)
    void powerUpImageButtonClicked(){
        powerUpImageButton.setImageResource(R.drawable.power_up_button_active);

        final Handler handler = new Handler();
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                powerUpImageButton.setImageResource(R.drawable.power_up_button);
            }
        }, 500);
    }

    public MainScreenController(Bundle args){
        super(args);
    }

    MainScreenController(String username){
        this.username = username;
        health = maxHealth;
    }

    @Override
    protected View inflateView(@NonNull LayoutInflater inflater, @NonNull ViewGroup container) {
        return inflater.inflate(R.layout.controller_main, container, false);
    }

    @Override
    protected void onViewBound(@NonNull View view) {
        super.onViewBound(view);

        setRetainViewMode(RetainViewMode.RETAIN_DETACH);

        Log.v("onViewBound", "onViewBound");

        if (socketStuff == null) {
            socketStuff = new SocketStuff(this);
        }

        socketStuff.registerSocket();

        if (position == null) {
            position = new Position(this);
            Log.v("MainScreenController", "Making new position");

        }

        if (position.mGoogleApiClient == null) {
            position.mGoogleApiClient = new GoogleApiClient.Builder(getApplicationContext())
                    .addConnectionCallbacks(position)
                    .addOnConnectionFailedListener(position)
                    .addApi(LocationServices.API)
                    .build();
        }

        position.mGoogleApiClient.connect();

        if (direction == null) {
            direction = new Direction(this);
            Log.v("MainScreenController", "Making new direction");
        }

        direction.registerListeners();

        mapStuff = new MapStuff(this);

        Log.v("onViewBound", "connected");
        updateBattery();
    }

    private void updateBattery(){
        int totalNumberOfBars = frameLayout.getChildCount();
        int barsPerHealth = totalNumberOfBars / maxHealth;
        int actualNumberOfBars = health * barsPerHealth;

        Log.v("updateBattery", "totalNumberOfBars: " + totalNumberOfBars);

        //9 bars
        //3 health
        //1 health = 3 bars

        for (int i = (totalNumberOfBars - 1); i > actualNumberOfBars; i--) {
            ImageView iv = (ImageView) frameLayout.getChildAt(i);

            iv.setVisibility(View.INVISIBLE);
        }
    }

    public LatLng getPosition(){
        return new LatLng(position.mLastLocation.getLatitude(), position.mLastLocation.getLongitude());
    }

    public void login(){
        String latitude = Double.toString(position.mLastLocation.getLatitude());
        String longitude = Double.toString(position.mLastLocation.getLongitude());
        String angle = Float.toString(direction.angle);
        socketStuff.emitLogin(username, latitude, longitude, angle);
    }

    public void updateData(){
        Log.v("updateData", "updateData");
        direction.updateOrientationAngles();
        direction.updateOrientationAngles();
        String latitude = "";
        String longitude = "";
        String angle = "";

        if (position.mLastLocation != null) {
            latitude = Double.toString(position.mLastLocation.getLatitude());
            longitude = Double.toString(position.mLastLocation.getLongitude());
        }
        angle = Float.toString(direction.angle);

        Log.v("updateData", "latitude: " + latitude);
        Log.v("updateData", "longitude: " + longitude);
        Log.v("updateData", "angle: " + angle);

        mapStuff.updateMapPosition();
        if (id != null) {
            socketStuff.emitUpdate(latitude, longitude, angle, id);
        }

        /*
        final Handler handler = new Handler();
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                updateData();
            }
        }, 2000);
        */
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String permissions[], @NonNull int[] grantResults) {
        switch (requestCode) {
            case PERMISSION_ACCESS_COARSE_LOCATION: {
                // If request is cancelled, the result arrays are empty.
                if ((grantResults.length > 0) && (grantResults[0] == PackageManager.PERMISSION_GRANTED)) {
                    Log.v("onReqPerm", "got coarse permission");
                    position.startLocationUpdates();
                } else {
                    Log.e("onReqPerm", "not got coarse permission");
                }
                return;
            }
            case PERMISSION_ACCESS_FINE_LOCATION: {
                // If request is cancelled, the result arrays are empty.
                if ((grantResults.length > 0) && (grantResults[0] == PackageManager.PERMISSION_GRANTED)) {
                    Log.v("onReqPerm", "got coarse permission");
                    position.startLocationUpdates();
                } else {
                    Log.e("onReqPerm", "not got fine permission");
                }
            }
        }
    }

    @Override
    protected void onDestroyView(View view){
        /*
        socketStuff.unregisterSocket();
        LocationServices.FusedLocationApi.removeLocationUpdates(position.mGoogleApiClient, position);
        position.mGoogleApiClient.disconnect();
        direction.mSensorManager.unregisterListener(direction);
        */
        Log.v("onDestroy", "disconnected");
    }
}
