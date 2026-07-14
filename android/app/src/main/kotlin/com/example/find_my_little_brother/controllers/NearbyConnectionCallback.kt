package com.example.find_my_little_brother.controllers

import android.util.Log
import com.example.find_my_little_brother.events.NearbyEvents
import com.google.android.gms.nearby.connection.ConnectionInfo
import com.google.android.gms.nearby.connection.ConnectionLifecycleCallback
import com.google.android.gms.nearby.connection.ConnectionResolution

class NearbyConnectionCallback :
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

    }

    override fun onConnectionResult(
        endpointId: String,
        result: ConnectionResolution
    ) {

        Log.d(
            TAG,
            "Connection result received"
        )

        NearbyEvents.connected(endpointId)

    }

    override fun onDisconnected(
        endpointId: String
    ) {

        Log.d(
            TAG,
            "Disconnected $endpointId"
        )

        NearbyEvents.disconnected(endpointId)

    }
}