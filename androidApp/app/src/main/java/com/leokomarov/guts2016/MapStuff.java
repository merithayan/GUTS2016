package com.leokomarov.guts2016;

import android.content.pm.PackageManager;
import android.graphics.drawable.Drawable;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.util.Log;

import com.leokomarov.guts2016.controllers.MainScreenController;
import com.mapbox.mapboxsdk.annotations.Icon;
import com.mapbox.mapboxsdk.annotations.IconFactory;
import com.mapbox.mapboxsdk.annotations.MarkerOptions;
import com.mapbox.mapboxsdk.camera.CameraPosition;
import com.mapbox.mapboxsdk.geometry.LatLng;
import com.mapbox.mapboxsdk.maps.MapboxMap;
import com.mapbox.mapboxsdk.maps.OnMapReadyCallback;

import static com.leokomarov.guts2016.Position.PERMISSION_ACCESS_COARSE_LOCATION;
import static com.leokomarov.guts2016.Position.PERMISSION_ACCESS_FINE_LOCATION;

public class MapStuff {

    private MainScreenController mainScreenController;
    private MapboxMap actualMap;
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
            }
        });

        IconFactory iconFactory = IconFactory.getInstance(mainScreenController.getActivity());
        Drawable enemyIconDrawable = ContextCompat.getDrawable(mainScreenController.getActivity(), R.drawable.ping_red);
        enemyIcon = iconFactory.fromDrawable(enemyIconDrawable);
    }

    public void addMarker(LatLng markerPosition){
        actualMap.addMarker(new MarkerOptions()
                .position(markerPosition)
                .title("Me")
                .snippet("Me again")
        .icon(enemyIcon));
    }

    public void updateMapPosition(){
        LatLng currentPosition = mainScreenController.getPosition();
        actualMap.setCameraPosition(new CameraPosition.Builder()
                .target(currentPosition)
                .zoom(16)
                .build());

        /*
        actualMap.addMarker(new MarkerOptions()
                .position(currentPosition)
                .title("Me")
                .snippet("Me again");

        LatLng currentPosition = new LatLng(55.871623, -4.287669);

                // Add the custom icon marker to the map
                meMarker = actualMap.addMarker(new MarkerOptions()
                        .position(currentPosition)
                        .title("Me")
                        .snippet("Me again"));

                CameraPosition cameraPosition = new CameraPosition.Builder()
                        .target(currentPosition) // Sets the new camera position
                        .zoom(17) // Sets the zoom
                        .tilt(0) // Set the camera tilt
                        .build(); // Creates a CameraPosition from the builder

                actualMap.animateCamera(CameraUpdateFactory.newCameraPosition(cameraPosition), 1000);
                */
    }
}
