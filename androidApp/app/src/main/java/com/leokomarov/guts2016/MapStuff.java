package com.leokomarov.guts2016;

import android.content.pm.PackageManager;
import android.graphics.drawable.Drawable;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.util.Log;

import com.leokomarov.guts2016.controllers.MainScreenController;
import com.mapbox.mapboxsdk.annotations.Icon;
import com.mapbox.mapboxsdk.annotations.IconFactory;
import com.mapbox.mapboxsdk.annotations.Marker;
import com.mapbox.mapboxsdk.annotations.MarkerViewOptions;
import com.mapbox.mapboxsdk.camera.CameraPosition;
import com.mapbox.mapboxsdk.geometry.LatLng;
import com.mapbox.mapboxsdk.maps.MapboxMap;
import com.mapbox.mapboxsdk.maps.OnMapReadyCallback;

import java.util.ArrayList;
import java.util.List;

import static com.leokomarov.guts2016.Position.PERMISSION_ACCESS_COARSE_LOCATION;
import static com.leokomarov.guts2016.Position.PERMISSION_ACCESS_FINE_LOCATION;

public class MapStuff {

    private MainScreenController mainScreenController;
    private MapboxMap actualMap;
    private List<Marker> markers;
    private ArrayList<String> listOfNames;

    private Icon enemyIcon;

    public MapStuff(MainScreenController mainScreenController){
        this.mainScreenController = mainScreenController;

        boolean notGotFineLocationPermission = ContextCompat.checkSelfPermission(mainScreenController.getActivity(), android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED;
        boolean notGotCoarseLocationPermission = ContextCompat.checkSelfPermission(mainScreenController.getActivity(), android.Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED;

        if (notGotCoarseLocationPermission) {
            Log.e("startLocationUpdates", "coarse permission not granted");
            ActivityCompat.requestPermissions(mainScreenController.getActivity(), new String[]{android.Manifest.permission.ACCESS_COARSE_LOCATION}, PERMISSION_ACCESS_COARSE_LOCATION);
        }

        if (notGotFineLocationPermission) {
            Log.e("startLocationUpdates", "fine permission not granted");
            ActivityCompat.requestPermissions(mainScreenController.getActivity(), new String[]{android.Manifest.permission.ACCESS_FINE_LOCATION}, PERMISSION_ACCESS_FINE_LOCATION);
        }


        mainScreenController.mapView.onCreate(MainActivity.bundle);
        mainScreenController.mapView.getMapAsync(new OnMapReadyCallback() {
            @Override
            public void onMapReady(MapboxMap mapboxMap) {
                actualMap = mapboxMap;
                actualMap.setMyLocationEnabled(true);
                markers = actualMap.getMarkers();
            }
        });

        IconFactory iconFactory = IconFactory.getInstance(mainScreenController.getActivity());
        Drawable enemyIconDrawable = ContextCompat.getDrawable(mainScreenController.getActivity(), R.drawable.ping_red);
        enemyIcon = iconFactory.fromDrawable(enemyIconDrawable);

        listOfNames = new ArrayList<>();
    }

    public void addMarker(String name, LatLng markerPosition){

        MarkerViewOptions marker = new MarkerViewOptions()
                .position(markerPosition)
                .title(name)
                .icon(enemyIcon);

        Log.v("addMarker", listOfNames.toString());

        if (! listOfNames.contains(name)) {
            Log.v("addMarker", "adding marker");
            listOfNames.add(name);
            actualMap.addMarker(marker);
        } else {
            Log.v("addMarker", "moving marker");
            actualMap.addMarker(marker).setPosition(markerPosition);
        }
    }

    public void updateMapPosition(){
        LatLng currentPosition = mainScreenController.getPosition();
        actualMap.setCameraPosition(new CameraPosition.Builder()
                .target(currentPosition)
                .zoom(16)
                .build());
    }
}
