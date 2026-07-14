package com.example.find_my_little_brother.services

import android.content.Context
import android.util.Log
import com.example.find_my_little_brother.controllers.AdvertisingController
import com.example.find_my_little_brother.controllers.ConnectionController
import com.example.find_my_little_brother.controllers.DiscoveryController
import com.google.android.gms.nearby.Nearby
import com.google.android.gms.nearby.connection.ConnectionLifecycleCallback
import com.google.android.gms.nearby.connection.ConnectionsClient
import com.google.android.gms.nearby.connection.EndpointDiscoveryCallback

class NearbyService(
    context: Context
) {

    companion object {

        private const val TAG = "NearbyService"

        const val SERVICE_ID =
            "com.example.find_my_little_brother"

    }

    private val client: ConnectionsClient =
        Nearby.getConnectionsClient(context)

    private val advertisingController =
        AdvertisingController(
            client,
            SERVICE_ID
        )

    private val discoveryController =
        DiscoveryController(
            client,
            SERVICE_ID
        )

    private val connectionController =
        ConnectionController(
            client
        )

    fun initialize(): String {

        Log.d(TAG, "Nearby initialized")

        return "Nearby Ready"

    }

    fun startAdvertising(
        deviceName: String,
        callback: ConnectionLifecycleCallback
    ): Boolean {

        val name =
            if (deviceName.isBlank())
                DeviceInfoService.getDeviceName()
            else
                deviceName

        return advertisingController.startAdvertising(
            name,
            callback
        )

    }

    fun stopAdvertising(): Boolean {

        advertisingController.stopAdvertising()

        return true

    }

    fun startDiscovery(
        callback: EndpointDiscoveryCallback
    ): Boolean {

        return discoveryController.startDiscovery(
            callback
        )

    }

    fun stopDiscovery(): Boolean {

        discoveryController.stopDiscovery()

        return true

    }

    fun requestConnection(
        endpointId: String,
        callback: ConnectionLifecycleCallback
    ): Boolean {

        return connectionController.requestConnection(
            DeviceInfoService.getDeviceName(),
            endpointId,
            callback
        )

    }

    fun disconnect(
        endpointId: String
    ): Boolean {

        return connectionController.disconnect(
            endpointId
        )

    }

}