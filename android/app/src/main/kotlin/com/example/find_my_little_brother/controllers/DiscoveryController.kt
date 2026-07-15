package com.example.find_my_little_brother.controllers

import android.util.Log
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
            return true
        }

        isDiscovering = true

        client.startDiscovery(
            serviceId,
            callback,
            DiscoveryOptions.Builder()
                .setStrategy(Strategy.P2P_STAR)
                .build()
        )
            .addOnSuccessListener {

                Log.d(TAG, "Discovery started")

            }
            .addOnFailureListener {

                isDiscovering = false

                Log.e(TAG, "Discovery failed", it)

            }

        return true
    }

    fun stopDiscovery() {

        client.stopDiscovery()
        isDiscovering = false

        Log.d(TAG, "Discovery stopped")

    }

}
