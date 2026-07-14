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

    fun startDiscovery(
        callback: EndpointDiscoveryCallback
    ): Boolean {

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

                Log.e(TAG, "Discovery failed", it)

            }

        return true
    }

    fun stopDiscovery() {

        client.stopDiscovery()

        Log.d(TAG, "Discovery stopped")

    }

}