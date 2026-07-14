package com.example.find_my_little_brother.controllers

import android.util.Log
import com.google.android.gms.nearby.connection.ConnectionLifecycleCallback
import com.google.android.gms.nearby.connection.ConnectionsClient

class ConnectionController(
    private val client: ConnectionsClient
) {

    companion object {
        private const val TAG = "ConnectionController"
    }

    fun requestConnection(
        endpointName: String,
        endpointId: String,
        callback: ConnectionLifecycleCallback
    ): Boolean {

        Log.d(TAG, "Requesting connection to $endpointName")

        client.requestConnection(
            endpointName,
            endpointId,
            callback
        )
            .addOnSuccessListener {

                Log.d(TAG, "Connection request sent")

            }
            .addOnFailureListener {

                Log.e(TAG, "Connection request failed", it)

            }

        return true
    }

        fun disconnect(
            endpointId: String
        ): Boolean {

            client.disconnectFromEndpoint(endpointId)

            Log.d(TAG, "Disconnected from $endpointId")

            return true
        }

}