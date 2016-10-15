package com.leokomarov.guts2016;

import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.util.Log;

public class Direction implements SensorEventListener {

    public SensorManager mSensorManager;
    public Sensor accelerometer;
    public Sensor magnetometer;

    private float[] mGravity;
    private float[] mGeomagnetic;
    private Float azimuth;

    public void onSensorChanged(SensorEvent event) {

        if (event.sensor.getType() == Sensor.TYPE_ACCELEROMETER) {
            mGravity = event.values;
        }

        if (event.sensor.getType() == Sensor.TYPE_MAGNETIC_FIELD) {
            mGeomagnetic = event.values;
        }

        Log.v("onSensorChanged", "1");
        Log.v("onSensorChanged", event.toString());

        if (mGravity != null && mGeomagnetic != null) {
            float R[] = new float[9];
            float I[] = new float[9];

            Log.v("onSensorChanged", "1");

            if (SensorManager.getRotationMatrix(R, I, mGravity, mGeomagnetic)) {

                Log.v("onSensorChanged", "2");

                // orientation contains azimuth, pitch and roll
                float orientation[] = new float[3];
                SensorManager.getOrientation(R, orientation);

                azimuth = orientation[0];
            }
        }
        float rotation = -azimuth * 360 / (2 * 3.14159f);
        Log.v("onSensorChanged", Float.toString(rotation));
        Log.v("onSensorChanged", Float.toString(azimuth));
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {}
}