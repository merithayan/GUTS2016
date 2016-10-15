package com.leokomarov.guts2016;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.ViewGroup;

import com.bluelinelabs.conductor.Conductor;
import com.bluelinelabs.conductor.Router;
import com.bluelinelabs.conductor.RouterTransaction;
import com.leokomarov.guts2016.home.HomeController;

import butterknife.BindView;
import butterknife.ButterKnife;

public class MainActivity extends AppCompatActivity {

    private Router router;
    public AppCompatActivity thisActivity;

    @BindView(R.id.controller_container)
    ViewGroup container;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        ButterKnife.bind(this);

        router = Conductor.attachRouter(this, container, savedInstanceState);

        //sets the root controller if it doesn't already exist
        //.with() returns a new RouterTransaction
        if (! router.hasRootController()){
            router.setRoot(RouterTransaction.with(new HomeController()));
        }
    }

    @Override
    public void onBackPressed(){
        if (! router.handleBack()){
            super.onBackPressed();
        }
    }
}
