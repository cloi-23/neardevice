package com.example.find_my_little_brother.controllers

import android.util.Log
import com.google.android.gms.nearby.connection.AdvertisingOptions
import com.google.android.gms.nearby.connection.ConnectionsClient
import com.google.android.gms.nearby.connection.ConnectionLifecycleCallback
import com.google.android.gms.nearby.connection.Strategy

class AdvertisingController(
    private val client: ConnectionsClient,
    private val serviceId: String
) {

    companion object {
        private const val TAG = "AdvertisingController"
    }

    fun startAdvertising(
        deviceName: String,
        callback: ConnectionLifecycleCallback
    ): Boolean {

        client.startAdvertising(
            deviceName,
            serviceId,
            callback,
            AdvertisingOptions.Builder()
                .setStrategy(Strategy.P2P_STAR)
                .build()
        ).addOnSuccessListener {

            Log.d(TAG, "Advertising started")

        }.addOnFailureListener {

            Log.e(TAG, "Advertising failed", it)

        }

        return true
    }

    fun stopAdvertising() {
        client.stopAdvertising()
        Log.d(TAG, "Advertising stopped")
    }
}