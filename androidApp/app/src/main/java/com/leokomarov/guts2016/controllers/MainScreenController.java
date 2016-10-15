package com.leokomarov.guts2016.controllers;

import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.NonNull;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.ImageView;

import com.github.nkzawa.socketio.client.IO;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.location.LocationServices;
import com.leokomarov.guts2016.Direction;
import com.leokomarov.guts2016.MainActivity;
import com.leokomarov.guts2016.Position;
import com.leokomarov.guts2016.R;
import com.leokomarov.guts2016.SocketStuff;
import com.mapbox.mapboxsdk.maps.MapView;
import com.mapbox.mapboxsdk.maps.MapboxMap;
import com.mapbox.mapboxsdk.maps.OnMapReadyCallback;

import java.net.URISyntaxException;

import butterknife.BindView;
import butterknife.OnClick;

import static com.leokomarov.guts2016.Position.PERMISSION_ACCESS_COARSE_LOCATION;
import static com.leokomarov.guts2016.Position.PERMISSION_ACCESS_FINE_LOCATION;
import static com.leokomarov.guts2016.R.id.mapview;

public class MainScreenController extends ButterKnifeController {

    public SocketStuff socketStuff;
    public Position position;
    public Direction direction;
    private String username;

    @BindView(mapview)
    MapView mapView;

    @BindView(R.id.batteryImage)
    ImageView batteryImageView;

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

    public MainScreenController(String username){
        this.username = username;
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
            try {
                socketStuff.mSocket = IO.socket("http://c9092951.ngrok.io/");
            } catch (URISyntaxException e) {
                Log.e("MainScreenController", e.getMessage());
            }
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

        mapView.onCreate(MainActivity.bundle);
        mapView.getMapAsync(new OnMapReadyCallback() {
            @Override
            public void onMapReady(MapboxMap mapboxMap) {

                // Interact with the map using mapboxMap here

            }
        });



        Log.v("onViewBound", "connected");
    }

    public void login(){
        String latitude = Double.toString(position.mLastLocation.getLatitude());
        String longitude = Double.toString(position.mLastLocation.getLongitude());
        socketStuff.emitLogin(username, latitude, longitude);
    }

    public void updateData(){
        Log.v("updateData", "updateData");
        if (position.mLastLocation != null) {
            Log.v("updateData", "latitude: " + position.mLastLocation.getLatitude());
            Log.v("updateData", "longitude: " + position.mLastLocation.getLongitude());
        }

        direction.updateOrientationAngles();
        //Log.v("updateData", "rotation: " + Float.toString(direction.rotation));

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
    protected void onDestroy(){
        socketStuff.unregisterSocket();
        LocationServices.FusedLocationApi.removeLocationUpdates(position.mGoogleApiClient, position);
        position.mGoogleApiClient.disconnect();
        direction.mSensorManager.unregisterListener(direction);
        Log.v("onDestroy", "disconnected");
    }
}
