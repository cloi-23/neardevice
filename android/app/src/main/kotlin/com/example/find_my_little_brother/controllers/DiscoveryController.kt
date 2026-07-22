package com.example.find_my_little_brother.controllers

import android.util.Log
import com.example.find_my_little_brother.events.NearbyEvents
import com.google.android.gms.nearby.connection.ConnectionsClient
import com.google.android.gms.nearby.connection.DiscoveryOptions
import com.google.android.gms.nearby.connection.EndpointDiscoveryCallback
import com.google.android.gms.nearby.connection.Strategy

class DiscoveryController(
    private val client: ConnectionsClient,
    private val serviceId: String
) {

    companion object {
        private const val TAG = "DiscoveryController"
    }

    private var isDiscovering = false

    fun startDiscovery(
        callback: EndpointDiscoveryCallback
    ): Boolean {

        if (isDiscovering) {
            Log.d(TAG, "Discovery is already active")
            NearbyEvents.status("Nearby discovery is already active.")
            return true
        }

        isDiscovering = true
        Log.d(TAG, "Starting discovery for service $serviceId")
        NearbyEvents.status("Starting nearby discovery...")

        client.startDiscovery(
            serviceId,
            callback,
            DiscoveryOptions.Builder()
                .setStrategy(Strategy.P2P_CLUSTER)
                .build()
        )
            .addOnSuccessListener {

                Log.d(TAG, "Discovery started")
                NearbyEvents.status("Nearby discovery started. Searching for devices...")

            }
            .addOnFailureListener {

                isDiscovering = false

                Log.e(TAG, "Discovery failed", it)
                NearbyEvents.status(
                    "Nearby discovery failed: ${it.localizedMessage ?: "unknown error"}"
                )

            }

        return true
    }

    fun stopDiscovery() {

        client.stopDiscovery()
        isDiscovering = false

        Log.d(TAG, "Discovery stopped")
        NearbyEvents.status("Nearby discovery stopped.")

    }

}
