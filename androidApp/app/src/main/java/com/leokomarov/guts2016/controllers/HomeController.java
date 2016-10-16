package com.leokomarov.guts2016.controllers;

import android.content.pm.PackageManager;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;

import com.bluelinelabs.conductor.RouterTransaction;
import com.bluelinelabs.conductor.changehandler.FadeChangeHandler;
import com.leokomarov.guts2016.R;

import butterknife.BindView;
import butterknife.OnClick;

import static com.leokomarov.guts2016.Position.PERMISSION_ACCESS_COARSE_LOCATION;
import static com.leokomarov.guts2016.Position.PERMISSION_ACCESS_FINE_LOCATION;

public class HomeController extends ButterKnifeController {

    @BindView(R.id.edittext1)
    EditText edittext1;

    @OnClick(R.id.submitButton)
    void submitButtonClicked(){
        String username = edittext1.getText().toString();
        getRouter().pushController(RouterTransaction.with(new MainScreenController(username))
                .pushChangeHandler(new FadeChangeHandler())
                .popChangeHandler(new FadeChangeHandler())
        );
    }

    @Override
    protected View inflateView(@NonNull LayoutInflater inflater, @NonNull ViewGroup container) {
        return inflater.inflate(R.layout.controller_home, container, false);
    }

    @Override
    protected void onViewBound(@NonNull View view) {
        super.onViewBound(view);
        setRetainViewMode(RetainViewMode.RELEASE_DETACH);

        boolean notGotFineLocationPermission = ContextCompat.checkSelfPermission(getActivity(), android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED;
        boolean notGotCoarseLocationPermission = ContextCompat.checkSelfPermission(getActivity(), android.Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED;

        if (notGotCoarseLocationPermission) {
            Log.e("HomeController", "coarse permission not granted");
            ActivityCompat.requestPermissions(getActivity(), new String[]{android.Manifest.permission.ACCESS_COARSE_LOCATION}, PERMISSION_ACCESS_COARSE_LOCATION);
        }

        if (notGotFineLocationPermission) {
            Log.e("HomeController", "fine permission not granted");
            ActivityCompat.requestPermissions(getActivity(), new String[]{android.Manifest.permission.ACCESS_FINE_LOCATION}, PERMISSION_ACCESS_FINE_LOCATION);
        }
    }
}
