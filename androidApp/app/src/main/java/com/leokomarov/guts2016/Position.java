package com.leokomarov.guts2016;

import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationManager;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AlertDialog;
import android.util.Log;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.location.LocationListener;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;
import com.leokomarov.guts2016.controllers.MainScreenController;

import java.text.DateFormat;
import java.util.Date;

public class Position implements GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener, LocationListener {

    public GoogleApiClient mGoogleApiClient;
    public Location mLastLocation;
    private String mLastUpdateTime;
    public static final int PERMISSION_ACCESS_COARSE_LOCATION = 1;
    public static final int PERMISSION_ACCESS_FINE_LOCATION = 2;

    private MainScreenController mainScreenController;

    public Position(MainScreenController mainScreenController){
        this.mainScreenController = mainScreenController;
    }

    public void startLocationUpdates() {
        Log.v("startLocationUpdates", "startLocationUpdates");

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

        LocationRequest mLocationRequest = new LocationRequest();
        mLocationRequest.setInterval(1000);
        mLocationRequest.setFastestInterval(1000);
        mLocationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
        LocationServices.FusedLocationApi.requestLocationUpdates(mGoogleApiClient, mLocationRequest, this);
        Log.v("startLocationUpdates", "requested LocationUpdates");
    }

    @Override
    public void onConnected(@Nullable Bundle bundle) {
        Log.v("onConnected", "onConnected");

        boolean notGotFineLocationPermission = ContextCompat.checkSelfPermission(mainScreenController.getActivity(), android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED;
        boolean notGotCoarseLocationPermission = ContextCompat.checkSelfPermission(mainScreenController.getActivity(), android.Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED;

        if (notGotCoarseLocationPermission) {
            Log.e("onConnected", "coarse permission not granted");
            ActivityCompat.requestPermissions(mainScreenController.getActivity(), new String[]{android.Manifest.permission.ACCESS_COARSE_LOCATION}, PERMISSION_ACCESS_COARSE_LOCATION);
            return;
        }

        if (notGotFineLocationPermission) {
            Log.e("onConnected", "fine permission not granted");
            ActivityCompat.requestPermissions(mainScreenController.getActivity(), new String[]{android.Manifest.permission.ACCESS_FINE_LOCATION}, PERMISSION_ACCESS_FINE_LOCATION);
            return;
        }

        Log.v("onConnected", "passed");

        LocationManager locationManager = (LocationManager) mainScreenController.getActivity().getSystemService(Context.LOCATION_SERVICE);
        if( ! locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER) ) {
            AlertDialog.Builder builder = new AlertDialog.Builder(mainScreenController.getActivity());
            builder.setTitle("GPS not found");  // GPS not found
            builder.setMessage("Would you like to turn it on?"); // Want to enable?
            builder.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
                public void onClick(DialogInterface dialogInterface, int i) {
                    mainScreenController.startActivity(new Intent(android.provider.Settings.ACTION_LOCATION_SOURCE_SETTINGS));
                }
            });
            builder.setNegativeButton("No", null);
            builder.create().show();
            return;
        }

        mLastLocation = LocationServices.FusedLocationApi.getLastLocation(mGoogleApiClient);
        mLastUpdateTime = DateFormat.getTimeInstance().format(new Date());

        startLocationUpdates();
        mainScreenController.updateData();
        mainScreenController.login();
    }

    @Override
    public void onConnectionSuspended(int i) {
        Log.e("onConnectionSuspended", "onConnectionSuspended");
    }

    @Override
    public void onConnectionFailed(@NonNull ConnectionResult connectionResult) {
        Log.e("onConnectionFailed", connectionResult.getErrorMessage());
    }

    @Override
    public void onLocationChanged(Location location) {
        mLastLocation = location;
        mLastUpdateTime = DateFormat.getTimeInstance().format(new Date());
        mainScreenController.updateData();
        Log.v("onLocationChanged", mLastUpdateTime);
    }
}
