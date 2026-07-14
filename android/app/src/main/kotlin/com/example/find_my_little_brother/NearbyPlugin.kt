package com.example.find_my_little_brother.plugin

import android.content.Context
import com.example.find_my_little_brother.controllers.NearbyConnectionCallback
import com.example.find_my_little_brother.controllers.NearbyDiscoveryCallback
import com.example.find_my_little_brother.generated.NearbyBridge
import com.example.find_my_little_brother.services.NearbyManager

class NearbyPlugin(
    context: Context
) : NearbyBridge {

    private val nearbyManager = NearbyManager(context)

    private val connectionCallback =
        NearbyConnectionCallback()

    private val discoveryCallback =
        NearbyDiscoveryCallback()

    override fun initialize(): String {
        return nearbyManager.initialize()
    }

    override fun startAdvertising(
        deviceName: String
    ): Boolean {

        return nearbyManager.startAdvertising(
            connectionCallback
        )

    }

    override fun stopAdvertising(): Boolean {
        return nearbyManager.stopAdvertising()
    }

    override fun startDiscovery(): Boolean {

        return nearbyManager.startDiscovery(
            discoveryCallback
        )

    }

    override fun stopDiscovery(): Boolean {
        return nearbyManager.stopDiscovery()
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