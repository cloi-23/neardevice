package com.example.find_my_little_brother.controllers

import android.util.Log
import com.example.find_my_little_brother.events.NearbyEvents
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

    private var isAdvertising = false

    fun startAdvertising(
        deviceName: String,
        callback: ConnectionLifecycleCallback
    ): Boolean {

        if (isAdvertising) {
            Log.d(TAG, "Advertising is already active")
            NearbyEvents.status("Nearby advertising is already active.")
            return true
        }

        isAdvertising = true
        Log.d(TAG, "Starting advertising for service $serviceId")
        NearbyEvents.status("Starting nearby advertising...")

        client.startAdvertising(
            deviceName,
            serviceId,
            callback,
            AdvertisingOptions.Builder()
                .setStrategy(Strategy.P2P_CLUSTER)
                .build()
        ).addOnSuccessListener {

            Log.d(TAG, "Advertising started")
            NearbyEvents.status("Nearby advertising started.")

        }.addOnFailureListener {

            isAdvertising = false

            Log.e(TAG, "Advertising failed", it)
            NearbyEvents.status(
                "Nearby advertising failed: ${it.localizedMessage ?: "unknown error"}"
            )

        }

        return true
    }

    fun stopAdvertising() {
        client.stopAdvertising()
        isAdvertising = false
        Log.d(TAG, "Advertising stopped")
        NearbyEvents.status("Nearby advertising stopped.")
    }
}
