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
        mSocket.on("logged-in", onLoggedIn);
        mSocket.on("update", onSocketUpdate);
        mSocket.connect();
    }

    public void unregisterSocket(){
        mSocket.disconnect();
        mSocket.off("logged-in", onLoggedIn);
        mSocket.off("update", onSocketUpdate);
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
            jo.put("lat", latitude);
            jo.put("lng", longitude);
            jo.put("angle", angle);
        } catch(Exception e) {
            Log.e("emitUpdate", e.getMessage());
        }
        Log.v("emitUpdate", jo.toString());

        mSocket.emit("update-player", jo);
    }

    private Emitter.Listener onSocketUpdate = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            mainScreenController.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    JSONObject data = (JSONObject) args[0];
                    //Log.v("onUpdate", data.toString());
                    String message ="abc";
                    /*
                    try {
                        message = "abc";//data.getString("message");
                    } catch (JSONException e) {
                        Log.e("Home-onNewMessage", e.getMessage());
                        return;
                    }
                    */
                    //logMessage(message);
                }
            });
        }
    };

    private Emitter.Listener onLoggedIn = new Emitter.Listener() {
        @Override
        public void call(final Object... args) {
            JSONObject data = (JSONObject) args[0];
            String id = "";
            Log.v("onLoggedIn", data.toString());

            try {
                id = data.getString("id");
            } catch (JSONException e) {
                Log.e("onLoggedIn", e.getMessage());
                return;
            }
            mainScreenController.id = id;
            logMessage(id);
        }
    };

    private void logMessage(String message){
        Log.v("logMessage", message);
    }
}
