package com.tealeaf.plugin.plugins;

import com.tealeaf.plugin.IPlugin;
import java.io.*;
import org.json.JSONException;
import org.json.JSONObject;

import com.kochava.base.Tracker;

import android.app.Activity;
import android.content.Intent;
import android.content.Context;
import android.util.Log;
import android.os.Bundle;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;

public class KochavaPlugin implements IPlugin {

  private Context mContext;
  private boolean DEBUG = false;

  public KochavaPlugin() {
  }

  public void onCreateApplication(Context applicationContext) {
    mContext = applicationContext;
  }

  public void onCreate(Activity activity, Bundle savedInstanceState) {

    PackageManager manager = activity.getPackageManager();
    String kochavaKey;
    try {
      Bundle meta = manager.getApplicationInfo(activity.getPackageName(), PackageManager.GET_META_DATA).metaData;

      if (meta != null) {
        kochavaKey = meta.get("kochavaAppGUID").toString();
        Tracker.configure(new Tracker.Configuration(mContext)
          .setAppGuid(kochavaKey));

        if (DEBUG) {
          Tracker.configure(new Tracker.Configuration(mContext).setLogLevel(Tracker.LOG_LEVEL_DEBUG));
        }
      }
    } catch (Exception e) {
      android.util.Log.d("Kochava EXCEPTION", "" + e.getMessage());
    }
  }

  public void setUserId(String json) {
    try {
      JSONObject data = new JSONObject(json);
      String userId = data.getString("uid");

      Tracker.setIdentityLink(new Tracker.IdentityLink()
        .add("user_id", userId));
    } catch (JSONException ex) {
      ex.printStackTrace();
    }
  }

  public void trackPurchase(String json) {
    String dataSignature;
    JSONObject receiptdata;
    String receipt;

    try {
      JSONObject data = new JSONObject(json);
      receipt = data.getString("receipt");

      receiptdata = new JSONObject(receipt);
      dataSignature = receiptdata.getString("dataSignature");

      Tracker.sendEvent(new Tracker.Event(Tracker.EVENT_TYPE_PURCHASE)
        .setGooglePlayReceipt(receipt, dataSignature)
        .setName(data.getString("productId"))
        .setCurrency(receiptdata.getString("localCurrency"))
        .setPrice(Double.parseDouble(receiptdata.getString("localPrice")))
      );

    } catch (JSONException ex) {
      ex.printStackTrace();
    }
  }

  public void onResume() {
  }

  public void onRenderResume() {
  }

  public void onStart() {
  }

  public void onFirstRun() {
  }

  public void onPause() {
  }

  public void onRenderPause() {
  }

  public void onStop() {
  }

  public void onDestroy() {
  }

  public void onNewIntent(Intent intent) {
  }

  public void setInstallReferrer(String referrer) {
  }

  public void onActivityResult(Integer request, Integer result, Intent data) {
  }

  public boolean consumeOnBackPressed() {
    return true;
  }

  public void onBackPressed() {
  }
}
