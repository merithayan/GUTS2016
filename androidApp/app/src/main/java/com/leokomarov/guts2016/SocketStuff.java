package com.leokomarov.guts2016;

import android.content.Context;
import android.os.Vibrator;
import android.text.TextUtils;
import android.util.Log;

import com.github.nkzawa.emitter.Emitter;
import com.github.nkzawa.socketio.client.IO;
import com.github.nkzawa.socketio.client.Socket;
import com.leokomarov.guts2016.controllers.MainScreenController;
import com.mapbox.mapboxsdk.geometry.LatLng;

import org.json.JSONException;
import org.json.JSONObject;

import java.net.URISyntaxException;
import java.util.Iterator;

public class SocketStuff {

    public Socket mSocket;
    private MainScreenController mainScreenController;

    public SocketStuff(MainScreenController mainScreenController){
        this.mainScreenController = mainScreenController;

        try {
            //mSocket = IO.socket("http://c9092951.ngrok.io/");
            mSocket = IO.socket("http://dmont.merithayan.com/");
        } catch (URISyntaxException e) {
            Log.e("MainScreenController", e.getMessage());
        }
    }

    public void registerSocket(){
        mSocket.on("logged-in", onLoggedIn);
        mSocket.on("update", onUpdateFromServer);
        mSocket.on("hit", onHit);
        mSocket.on("got-shot", onGotShot);
        mSocket.connect();
    }

    public void unregisterSocket(){
        mSocket.disconnect();
        mSocket.on("got-shot", onGotShot);
        mSocket.on("hit", onHit);
        mSocket.off("logged-in", onLoggedIn);
        mSocket.off("update", onUpdateFromServer);
    }

    public void emitLogin(String username, String latitude, String longitude, String angle) {
        Log.v("emitLogin", " ");
        if (TextUtils.isEmpty(username)) {
            Log.e("emitLogin", "empty");
            return;
        }

        JSONObject jo = new JSONObject();
        try {
            jo.put("name", username);
            jo.put("lat", latitude);
            jo.put("lng", longitude);
            jo.put("angle", angle);
        } catch(Exception e) {
            Log.e("emitLogin", e.getMessage());
        }
        Log.v("emitLogin", jo.toString());

        mSocket.emit("login", jo);
    }

    public void emitUpdate(String latitude, String longitude, String angle, String id) {
        Log.v("emitUpdate", " ");
        Log.v("emitUpdate", "id: " + id);

        JSONObject jo = new JSONObject();
        try {
            jo.put("id", id);
            if (mainScreenController.EMPed){
                jo.put("lat", 1.2921);
                jo.put("lng", 36.8219);
            } else {
                jo.put("lat", latitude);
                jo.put("lng", longitude);
            }
            jo.put("angle", angle);
        } catch(Exception e) {
            Log.e("emitUpdate", e.getMessage());
        }
        Log.v("emitUpdate", jo.toString());

        mSocket.emit("update-player", jo);
    }

    private Emitter.Listener onUpdateFromServer = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            mainScreenController.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    //bmainScreenController.mapStuff.removeAllMarkers();
                    JSONObject data = (JSONObject) args[0];

                    if (data.length() != 0) {
                        //Log.v("onUpdate", data.toString());

                        try {
                            Iterator<?> keys = data.keys();
                            while (keys.hasNext()) {
                                String key = (String) keys.next();
                                if (data.get(key) instanceof JSONObject) {
                                    JSONObject person = (JSONObject) data.get(key);
                                    String name = (String) person.get("name");
                                    //Log.v("onUpdate", name);
                                    if (! mainScreenController.username.equals(name)) {
                                        Double latitude;
                                        Double longitude;
                                        try {
                                            latitude = Double.parseDouble((String) person.get("lat"));
                                            longitude = Double.parseDouble((String) person.get("lng"));
                                        } catch (ClassCastException e) {
                                            latitude = (Double) person.get("lat");
                                            longitude = (Double) person.get("lng");
                                        }

                                        LatLng position = new LatLng(latitude, longitude);
                                        //Log.v("onUpdate", name + ": " + position.toString());

                                        mainScreenController.mapStuff.addMarker(name, position);
                                    } else {

                                        boolean hasEMP;
                                        try {
                                            hasEMP = Boolean.parseBoolean((String) person.get("hasEmp"));
                                        } catch (ClassCastException e) {
                                            hasEMP = (Boolean) person.get("hasEmp");
                                        }
                                        mainScreenController.hasEMP = hasEMP;
                                        mainScreenController.changePowerUpButton();

                                        boolean EMPed;
                                        try {
                                            EMPed = Boolean.parseBoolean((String) person.get("empd"));
                                        } catch (ClassCastException e) {
                                            EMPed = (Boolean) person.get("empd");
                                        }
                                        Log.v("onUpdate", "EMPed: " + EMPed);
                                        mainScreenController.EMPed = EMPed;

                                        int health;
                                        try {
                                            health = Integer.parseInt((String) person.get("health"));
                                        } catch (ClassCastException e) {
                                            health = (Integer) person.get("health");
                                        }
                                        if (mainScreenController.health != health) {
                                            mainScreenController.health = health;
                                            mainScreenController.updateBattery();
                                        }

                                        final String experience;
                                        String experienceTemp;
                                        try {
                                            experienceTemp = (String) person.get("experience");
                                        } catch (ClassCastException e) {
                                            experienceTemp = ((Integer) person.get("experience")).toString();
                                        }
                                        experience = experienceTemp;
                                        Log.v("onUpdate","experience: " +  experience);
                                        mainScreenController.getActivity().runOnUiThread(new Runnable() {
                                            @Override
                                            public void run() {
                                                mainScreenController.expTextview.setText("exp: " + experience);
                                            }
                                        });

                                        Log.v("onUpdate", "health: " + health);

                                        if (health <= 0) {
                                            mainScreenController.timeOut();
                                        }
                                    }
                                }
                            }
                        } catch (JSONException e) {
                            Log.e("onUpdate", e.getMessage());
                            return;
                        }

                    }
                }
            });
        }
    };

    private Emitter.Listener onLoggedIn = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            String id = (String) args[0];
            Log.v("onLoggedIn", id);
            mainScreenController.id = id;
            logMessage(id);
        }
    };

    private Emitter.Listener onHit = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            final String target = (String) args[0];
            Log.v("onHit", target);
            mainScreenController.getActivity().runOnUiThread(new Runnable() {
                 @Override
                 public void run() {
                    mainScreenController.shotTextview.setText("You shot " + target);
                 }
            });

            Vibrator v = (Vibrator) mainScreenController.getActivity().getSystemService(Context.VIBRATOR_SERVICE);
            v.vibrate(500);
        }
    };

    private Emitter.Listener onGotShot = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            final String shooter = (String) args[0];
            Log.v("onGotShot", shooter);
            mainScreenController.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    mainScreenController.shotTextview.setText("You were shot by " + shooter);
                }
            });

            Vibrator v = (Vibrator) mainScreenController.getActivity().getSystemService(Context.VIBRATOR_SERVICE);
            v.vibrate(500);
        }
    };

    private void logMessage(String message){
        Log.v("logMessage", message);
    }
}
