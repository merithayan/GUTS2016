package com.leokomarov.guts2016;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.ViewGroup;

import com.bluelinelabs.conductor.Conductor;
import com.bluelinelabs.conductor.Router;
import com.bluelinelabs.conductor.RouterTransaction;
import com.bluelinelabs.conductor.changehandler.FadeChangeHandler;
import com.leokomarov.guts2016.controllers.HomeController;
import com.mapbox.mapboxsdk.MapboxAccountManager;

import butterknife.BindView;
import butterknife.ButterKnife;

public class MainActivity extends AppCompatActivity {

    private Router router;
    private final String API_KEY = "pk.eyJ1IjoibmQ5NjAwIiwiYSI6ImNpdWI2MnVrbTAwMGcydHBpb3drc2JxZzMifQ.kLhkRE4MLh55VYT_I1xiBA";

    public static Bundle bundle;

    @BindView(R.id.controller_container)
    ViewGroup container;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        ButterKnife.bind(this);

        bundle = savedInstanceState;
        MapboxAccountManager.start(this, API_KEY);

        router = Conductor.attachRouter(this, container, savedInstanceState);

        //sets the root controller if it doesn't already exist
        //.with() returns a new RouterTransaction
        if (! router.hasRootController()){
            router.setRoot(RouterTransaction.with(new HomeController())
                    .pushChangeHandler(new FadeChangeHandler())
                    .popChangeHandler(new FadeChangeHandler()));
        }
    }

    @Override
    public void onBackPressed(){
        if (! router.handleBack()){
            super.onBackPressed();
        }
    }
}
