package com.example.find_my_little_brother.controllers

import android.util.Log
import com.example.find_my_little_brother.events.NearbyEvents
import com.google.android.gms.nearby.connection.ConnectionInfo
import com.google.android.gms.nearby.connection.ConnectionLifecycleCallback
import com.google.android.gms.nearby.connection.ConnectionResolution
import com.google.android.gms.nearby.connection.ConnectionsStatusCodes

class NearbyConnectionCallback(
    private val connectionController: ConnectionController,
    private val payloadController: PayloadController
) :
    ConnectionLifecycleCallback() {

    companion object {
        private const val TAG = "NearbyConnection"
    }

    override fun onConnectionInitiated(
        endpointId: String,
        connectionInfo: ConnectionInfo
    ) {

        Log.d(
            TAG,
            "Connection initiated from ${connectionInfo.endpointName}"
        )

        connectionController.acceptConnection(
            endpointId,
            payloadController.callback
        )

    }

    override fun onConnectionResult(
        endpointId: String,
        result: ConnectionResolution
    ) {

        if (result.status.statusCode == ConnectionsStatusCodes.STATUS_OK) {
            connectionController.markConnected(endpointId)
            Log.d(TAG, "Connected to $endpointId")
            NearbyEvents.connected(endpointId)
            payloadController.sendTextPayload(endpointId, "Hello")
        } else {
            connectionController.markDisconnected(endpointId)
            Log.e(TAG, "Connection failed for $endpointId: ${result.status}")
        }

    }

    override fun onDisconnected(
        endpointId: String
    ) {

        connectionController.markDisconnected(endpointId)

        Log.d(
            TAG,
            "Disconnected $endpointId"
        )

        NearbyEvents.disconnected(endpointId)

    }
}
