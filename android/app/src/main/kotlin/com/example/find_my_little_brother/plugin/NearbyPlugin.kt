package com.example.find_my_little_brother.plugin

import android.content.Context
import com.example.find_my_little_brother.controllers.NearbyConnectionCallback
import com.example.find_my_little_brother.controllers.NearbyDiscoveryCallback
import com.example.find_my_little_brother.generated.NearbyBridge
import com.example.find_my_little_brother.services.NearbyService

class NearbyPlugin(
    context: Context
) : NearbyBridge {

    private val nearbyService = NearbyService(context)

    private val connectionCallback =
        NearbyConnectionCallback()

    private val discoveryCallback =
        NearbyDiscoveryCallback()

    override fun initialize(): String {
        return nearbyService.initialize()
    }

    override fun startAdvertising(
        deviceName: String
    ): Boolean {

        return nearbyService.startAdvertising(
            deviceName,
            connectionCallback
        )

    }

    override fun stopAdvertising(): Boolean {
        return nearbyService.stopAdvertising()
    }

    override fun startDiscovery(): Boolean {

        return nearbyService.startDiscovery(
            discoveryCallback
        )

    }

    override fun stopDiscovery(): Boolean {
        return nearbyService.stopDiscovery()
    }

    override fun disconnect(): Boolean {
        return false
    }

    override fun sendMessage(
        endpointId: String,
        message: String
    ): Boolean {
        return false
    }
}