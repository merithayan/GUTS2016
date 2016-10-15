package com.leokomarov.guts2016.home;

import android.content.pm.PackageManager;
import android.hardware.Sensor;
import android.hardware.SensorManager;
import android.os.Handler;
import android.support.annotation.NonNull;
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
import com.github.nkzawa.socketio.client.IO;
import com.github.nkzawa.socketio.client.Socket;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.location.LocationServices;
import com.leokomarov.guts2016.Direction;
import com.leokomarov.guts2016.Position;
import com.leokomarov.guts2016.R;
import com.leokomarov.guts2016.controllers.ButterKnifeController;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.net.URISyntaxException;

import butterknife.BindView;
import butterknife.OnClick;

import static android.content.Context.SENSOR_SERVICE;
import static com.leokomarov.guts2016.Position.PERMISSION_ACCESS_COARSE_LOCATION;
import static com.leokomarov.guts2016.Position.PERMISSION_ACCESS_FINE_LOCATION;

public class HomeController extends ButterKnifeController {

    private Socket mSocket;
    private Position position;
    private Direction direction;

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

        /*
        JSONObject jo = new JSONObject();
        try {
            jo.put("name", message);
            jo.put("lat", String.valueOf(mLastLocation.getLatitude()));
            jo.put("lng", String.valueOf(mLastLocation.getLongitude()));
        } catch(Exception e) {
            Log.e("attemptSend", e.getMessage());
        }
        */

        mSocket.emit("fire");

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
        attemptSend();
    }

    public HomeController(){
        try {
            mSocket = IO.socket("http://c9092951.ngrok.io/");
        } catch (URISyntaxException e) {
            Log.e("HomeController", e.getMessage());
        }
    }

    @Override
    protected View inflateView(@NonNull LayoutInflater inflater, @NonNull ViewGroup container) {
        return inflater.inflate(R.layout.controller_home, container, false);
    }

    @Override
    public void onAttach(View view){
        position = new Position(this);
        direction = new Direction();
        direction.mSensorManager = (SensorManager) getActivity().getSystemService(SENSOR_SERVICE);
        direction.accelerometer = direction.mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
        direction.magnetometer = direction.mSensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD);

        Log.v("onAttach", "onAttach");
    }

    @Override
    protected void onViewBound(@NonNull View view) {
        super.onViewBound(view);

        setRetainViewMode(RetainViewMode.RETAIN_DETACH);

        mSocket.on("new message", onNewMessage);
        mSocket.on("update", onSocketUpdate);
        mSocket.connect();

        if (position == null) {
            position = new Position(this);
        }

        if (direction == null) {
            direction = new Direction();
            direction.mSensorManager = (SensorManager) getActivity().getSystemService(SENSOR_SERVICE);
            direction.accelerometer = direction.mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
            direction.magnetometer = direction.mSensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD);
        }

        if (position.mGoogleApiClient == null) {
            position.mGoogleApiClient = new GoogleApiClient.Builder(getApplicationContext())
                    .addConnectionCallbacks(position)
                    .addOnConnectionFailedListener(position)
                    .addApi(LocationServices.API)
                    .build();
        }

        position.mGoogleApiClient.connect();

        direction.mSensorManager.registerListener(direction, direction.accelerometer, SensorManager.SENSOR_DELAY_UI);

        Log.v("onViewBound", "connected");
    }

    public void updateUI(){
        Log.v("updateUI", "updateUI");
        if (position.mLastLocation != null) {
            latitudeTV.setText(String.valueOf(position.mLastLocation.getLatitude()));
            longitudeTV.setText(String.valueOf(position.mLastLocation.getLongitude()));
            Log.v("onLocationChanged", "latitude: " + position.mLastLocation.getLatitude());
            Log.v("onLocationChanged", "longitude: " + position.mLastLocation.getLongitude());
        }
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
        mSocket.disconnect();
        mSocket.off("new message", onNewMessage);
        mSocket.off("update", onSocketUpdate);
        LocationServices.FusedLocationApi.removeLocationUpdates(position.mGoogleApiClient, position);
        position.mGoogleApiClient.disconnect();
        direction.mSensorManager.unregisterListener(direction);
        Log.v("onDestroy", "disconnected");
    }

    private void attemptSend() {
        String message = edittext1.getText().toString();
        if (TextUtils.isEmpty(message)) {
            return;
        }

        JSONObject jo = new JSONObject();
        try {
            jo.put("name", message);
            jo.put("lat", String.valueOf(position.mLastLocation.getLatitude()));
            jo.put("lng", String.valueOf(position.mLastLocation.getLongitude()));
        } catch(Exception e) {
            Log.e("attemptSend", e.getMessage());
        }

        mSocket.emit("login", jo);
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

    private Emitter.Listener onSocketUpdate = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    JSONArray data = (JSONArray) args[0];
                    Log.v("onUpdate", data.toString());
                    String message ="abc";
                    /*
                    try {
                        message = "abc";//data.getString("message");
                    } catch (JSONException e) {
                        Log.e("Home-onNewMessage", e.getMessage());
                        return;
                    }
                    */
                    logMessage(message);
                }
            });
        }
    };

    private void logMessage(String message){
        Log.v("logMessage", message);
    }
}
