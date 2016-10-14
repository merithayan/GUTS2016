package com.leokomarov.guts2016.home;

import android.support.annotation.NonNull;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.leokomarov.guts2016.R;
import com.leokomarov.guts2016.controllers.ButterKnifeController;

public class HomeController extends ButterKnifeController {

    @Override
    protected View inflateView(@NonNull LayoutInflater inflater, @NonNull ViewGroup container) {
        return inflater.inflate(R.layout.controller_home, container, false);
    }

    @Override
    protected void onViewBound(@NonNull View view) {
        super.onViewBound(view);

        setRetainViewMode(RetainViewMode.RETAIN_DETACH);
    }
}
