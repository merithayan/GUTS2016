package com.leokomarov.guts2016;

import android.text.TextUtils;
import android.util.Log;

import com.github.nkzawa.emitter.Emitter;
import com.github.nkzawa.socketio.client.Socket;
import com.leokomarov.guts2016.controllers.MainScreenController;

import org.json.JSONException;
import org.json.JSONObject;

public class SocketStuff {

    public Socket mSocket;
    private MainScreenController mainScreenController;

    public SocketStuff(MainScreenController mainScreenController){
        this.mainScreenController = mainScreenController;
    }

    public void registerSocket(){
        mSocket.on("new message", onNewMessage);
        mSocket.on("update", onSocketUpdate);
        mSocket.connect();
    }

    public void unregisterSocket(){
        mSocket.disconnect();
        mSocket.off("new message", onNewMessage);
        mSocket.off("update", onSocketUpdate);
    }

    public void emitLogin(String username) {
        if (TextUtils.isEmpty(username)) {
            return;
        }

        JSONObject jo = new JSONObject();
        try {
            jo.put("name", username);
            jo.put("lat", String.valueOf(mainScreenController.position.mLastLocation.getLatitude()));
            jo.put("lng", String.valueOf(mainScreenController.position.mLastLocation.getLongitude()));
        } catch(Exception e) {
            Log.e("emitLogin", e.getMessage());
        }
        Log.v("emitLogin", jo.toString());

        mSocket.emit("login", jo);
    }

    private Emitter.Listener onNewMessage = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            mainScreenController.getActivity().runOnUiThread(new Runnable() {
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
            mainScreenController.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    JSONObject data = (JSONObject) args[0];
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
