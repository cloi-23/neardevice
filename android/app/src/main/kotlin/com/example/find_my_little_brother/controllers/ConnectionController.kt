package com.example.find_my_little_brother.controllers

import android.util.Log
import com.google.android.gms.nearby.connection.ConnectionLifecycleCallback
import com.google.android.gms.nearby.connection.ConnectionsClient
import com.google.android.gms.nearby.connection.PayloadCallback

class ConnectionController(
    private val client: ConnectionsClient
) {

    companion object {
        private const val TAG = "ConnectionController"
    }

    private val pendingEndpoints = mutableSetOf<String>()
    private val connectedEndpoints = mutableSetOf<String>()

    fun requestConnection(
        endpointName: String,
        endpointId: String,
        callback: ConnectionLifecycleCallback
    ): Boolean {

        if (endpointId in pendingEndpoints || endpointId in connectedEndpoints) {
            Log.d(TAG, "Connection already active or pending for $endpointId")
            return false
        }

        pendingEndpoints.add(endpointId)

        Log.d(
            TAG,
            "Requesting connection from $endpointName to endpoint $endpointId"
        )

        client.requestConnection(
            endpointName,
            endpointId,
            callback
        )
            .addOnSuccessListener {

                Log.d(TAG, "Connection request sent")

            }
            .addOnFailureListener {

                pendingEndpoints.remove(endpointId)

                Log.e(TAG, "Connection request failed", it)

            }

        return true
    }

    fun acceptConnection(
        endpointId: String,
        payloadCallback: PayloadCallback
    ): Boolean {

        client.acceptConnection(endpointId, payloadCallback)
            .addOnSuccessListener {
                Log.d(TAG, "Connection accepted for $endpointId")
            }
            .addOnFailureListener {
                Log.e(TAG, "Failed to accept connection for $endpointId", it)
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

    fun markConnected(endpointId: String) {
        pendingEndpoints.remove(endpointId)
        connectedEndpoints.add(endpointId)
    }

    fun markDisconnected(endpointId: String) {
        pendingEndpoints.remove(endpointId)
        connectedEndpoints.remove(endpointId)
    }

}
