package com.leokomarov.guts2016.home;

import android.Manifest;
import android.content.pm.PackageManager;
import android.location.Location;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;

import com.github.nkzawa.emitter.Emitter;
import com.github.nkzawa.socketio.client.Socket;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.location.LocationListener;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;
import com.leokomarov.guts2016.R;
import com.leokomarov.guts2016.controllers.ButterKnifeController;

import org.json.JSONException;
import org.json.JSONObject;

import java.text.DateFormat;
import java.util.Date;

import butterknife.BindView;
import butterknife.OnClick;

public class HomeController extends ButterKnifeController implements GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener, LocationListener {

    private Socket mSocket;
    private GoogleApiClient mGoogleApiClient;
    private Location mLastLocation;
    private LocationRequest mLocationRequest;
    private String mLastUpdateTime;
    private final int PERMISSION_ACCESS_COARSE_LOCATION = 1;
    private final int PERMISSION_ACCESS_FINE_LOCATION = 2;

    @BindView(R.id.edittext1)
    EditText edittext1;

    @BindView(R.id.latitudeTV)
    TextView latitudeTV;

    @BindView(R.id.longitudeTV)
    TextView longitudeTV;

    @BindView(R.id.batteryImage)
    ImageView batterImageView;

    @BindView(R.id.fireButton)
    ImageButton fireImageButton;

    @BindView(R.id.powerUpButton)
    ImageButton powerUpImageButton;

    @OnClick(R.id.fireButton)
    void fireImageButtonClicked(){
        fireImageButton.setImageResource(R.drawable.fire_button_active);

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


    @OnClick(R.id.submitButton)
    void submitButtonClicked(){
        Log.v("submit", "button clicked");
        //attemptSend();
    }

    public HomeController(){
        /*
        try {
            mSocket = IO.socket("http://chat.socket.io");
        } catch (URISyntaxException e) {
            Log.e("HomeController", e.getMessage());
        }
        */
    }

    @Override
    protected View inflateView(@NonNull LayoutInflater inflater, @NonNull ViewGroup container) {
        return inflater.inflate(R.layout.controller_home, container, false);
    }

    @Override
    protected void onViewBound(@NonNull View view) {
        super.onViewBound(view);

        setRetainViewMode(RetainViewMode.RETAIN_DETACH);

        //mSocket.on("new message", onNewMessage);
        //mSocket.connect();

        if (mGoogleApiClient == null) {
            //Log.e("blah", "blah");
            mGoogleApiClient = new GoogleApiClient.Builder(getApplicationContext())
                    .addConnectionCallbacks(this)
                    .addOnConnectionFailedListener(this)
                    .addApi(LocationServices.API)
                    .build();
        }

        mGoogleApiClient.connect();
        Log.v("onViewBound", "connected");
    }

    protected void createLocationRequest() {
        mLocationRequest = new LocationRequest();
        mLocationRequest.setInterval(1000);
        mLocationRequest.setFastestInterval(1000);
        mLocationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
    }

    protected void startLocationUpdates() {
        boolean notGotFineLocationPermission = ContextCompat.checkSelfPermission(getActivity(), Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED;
        boolean notGotCoarseLocationPermission = ContextCompat.checkSelfPermission(getApplicationContext(), Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED;

        if (notGotCoarseLocationPermission) {
            Log.e("startLocationUpdates", "coarse permission not granted");
            ActivityCompat.requestPermissions(getActivity(), new String[]{Manifest.permission.ACCESS_COARSE_LOCATION}, PERMISSION_ACCESS_COARSE_LOCATION);
        }

        if (notGotFineLocationPermission) {
            Log.e("startLocationUpdates", "fine permission not granted");
            ActivityCompat.requestPermissions(getActivity(), new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, PERMISSION_ACCESS_FINE_LOCATION);
        }

        createLocationRequest();
        LocationServices.FusedLocationApi.requestLocationUpdates(mGoogleApiClient, mLocationRequest, this);
    }

    @Override
    public void onConnected(@Nullable Bundle bundle) {
        Log.v("onConnected", "onConnected");

        boolean notGotFineLocationPermission = ContextCompat.checkSelfPermission(getActivity(), Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED;
        boolean notGotCoarseLocationPermission = ContextCompat.checkSelfPermission(getApplicationContext(), Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED;

        if (notGotCoarseLocationPermission) {
            Log.e("startLocationUpdates", "coarse permission not granted");
            ActivityCompat.requestPermissions(getActivity(), new String[]{Manifest.permission.ACCESS_COARSE_LOCATION}, PERMISSION_ACCESS_COARSE_LOCATION);
        }

        if (notGotFineLocationPermission) {
            Log.e("startLocationUpdates", "fine permission not granted");
            ActivityCompat.requestPermissions(getActivity(), new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, PERMISSION_ACCESS_FINE_LOCATION);
        }

        Log.v("onConnected", "passed");

        mLastLocation = LocationServices.FusedLocationApi.getLastLocation(mGoogleApiClient);
        mLastUpdateTime = DateFormat.getTimeInstance().format(new Date());
        updateUI();
        startLocationUpdates();

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
        updateUI();
        Log.v("onLocationChanged", mLastUpdateTime);
    }

    private void updateUI(){
        Log.v("updateUI", "updateUI");
        if (mLastLocation != null) {
            latitudeTV.setText(String.valueOf(mLastLocation.getLatitude()));
            longitudeTV.setText(String.valueOf(mLastLocation.getLongitude()));
            Log.v("onLocationChanged", "latitude: " + mLastLocation.getLatitude());
            Log.v("onLocationChanged", "longitude: " + mLastLocation.getLongitude());
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String permissions[], @NonNull int[] grantResults) {
        switch (requestCode) {
            case PERMISSION_ACCESS_COARSE_LOCATION: {
                // If request is cancelled, the result arrays are empty.
                if ((grantResults.length > 0) && (grantResults[0] == PackageManager.PERMISSION_GRANTED)) {
                    Log.v("onReqPerm", "got coarse permission");
                    startLocationUpdates();
                } else {
                    Log.e("onReqPerm", "not got coarse permission");
                }
                return;
            }
            case PERMISSION_ACCESS_FINE_LOCATION: {
                // If request is cancelled, the result arrays are empty.
                if ((grantResults.length > 0) && (grantResults[0] == PackageManager.PERMISSION_GRANTED)) {
                    Log.v("onReqPerm", "got coarse permission");
                    startLocationUpdates();
                } else {
                    Log.e("onReqPerm", "not got fine permission");
                }
            }
        }
    }

    @Override
    protected void onDestroy(){
        //mSocket.disconnect();
        //mSocket.off("new message", onNewMessage);
        LocationServices.FusedLocationApi.removeLocationUpdates(mGoogleApiClient, this);
        mGoogleApiClient.disconnect();
        Log.v("onDestroy", "disconnected");
    }

    private void attemptSend() {
        String message = edittext1.getText().toString();
        if (TextUtils.isEmpty(message)) {
            return;
        }
        mSocket.emit("new message", message);
    }

    private Emitter.Listener onNewMessage = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    JSONObject data = (JSONObject) args[0];
                    String message;
                    try {
                        message = data.getString("message");
                    } catch (JSONException e) {
                        Log.e("Home-onNewMessage", e.getMessage());
                        return;
                    }
                    logMessage(message);
                }
            });
        }
    };

    private void logMessage(String message){
        Log.v("logMessage", message);
    }
}
