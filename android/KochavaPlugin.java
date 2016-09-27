package com.tealeaf.plugin.plugins;

import com.tealeaf.logger;
import com.tealeaf.plugin.IPlugin;
import java.io.*;
import java.util.Map;
import java.util.HashMap;
import org.json.JSONException;
import org.json.JSONObject;

import com.kochava.android.tracker.Feature;

import android.app.Activity;
import android.content.Intent;
import android.content.Context;
import android.util.Log;
import android.os.Bundle;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;

public class KochavaPlugin implements IPlugin {

	private Feature kTracker;
	private Activity mActivity;
	private Context mContext;
	private boolean DEBUG = true;

	public KochavaPlugin() {
	}

	public void onCreateApplication(Context applicationContext) {
		mContext = applicationContext;
	}

	public void onCreate(Activity activity, Bundle savedInstanceState) {
		this.mActivity = activity;

		PackageManager manager = activity.getPackageManager();
		String kochavaKey = "";
		try {
			Bundle meta = manager.getApplicationInfo(activity.getPackageName(), PackageManager.GET_META_DATA).metaData;

			if (meta != null) {
				kochavaKey = meta.get("kochavaAppGUID").toString();
			}
		} catch (Exception e) {
			android.util.Log.d("Kochava EXCEPTION", "" + e.getMessage());
		}

		kTracker = new Feature (mContext, kochavaKey);
		kTracker.setErrorDebug(DEBUG);
		kTracker.enableDebug(DEBUG);
	}

	public void setUserId(String json) {
		try {
			JSONObject data = new JSONObject(json);
			String userId = data.getString("uid");

			Map<String, String> send_data = new HashMap<String, String>();
			send_data.put("uid" , userId);
			kTracker.linkIdentity(send_data);
		} catch (JSONException ex) {
			ex.printStackTrace();
		}
	}

	public void trackPurchase(String json) {
		try {
			JSONObject data = new JSONObject(json);
			String receipt = data.getString("receipt");

			JSONObject receiptdata = new JSONObject(receipt);

			String purchaseData = receiptdata.getString("purchaseData");
			String dataSignature = receiptdata.getString("dataSignature");

			// place the Purchase Data and Data Signature into an object to pass to the method
			HashMap < String, String > receiptObject = new HashMap < String, String > ();
			receiptObject.put("purchaseData", purchaseData);
			receiptObject.put("dataSignature", dataSignature);
			kTracker.eventWithReceipt("Purchase", json, receiptObject);
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
