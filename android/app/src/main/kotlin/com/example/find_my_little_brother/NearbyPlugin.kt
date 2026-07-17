package com.example.find_my_little_brother.plugin

import android.content.Context
import com.example.find_my_little_brother.controllers.NearbyDiscoveryCallback
import com.example.find_my_little_brother.generated.NearbyBridge
import com.example.find_my_little_brother.services.NearbyManager

class NearbyPlugin(
    context: Context
) : NearbyBridge {

    private val nearbyManager = NearbyManager(context)

    private val discoveryCallback =
        NearbyDiscoveryCallback()

    override fun initialize(): String {
        return nearbyManager.initialize()
    }

    override fun startAdvertising(
        deviceName: String
    ): Boolean {

        return nearbyManager.startAdvertising()

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

    override fun requestConnection(endpointId: String): Boolean {
        return nearbyManager.requestConnection(endpointId)
    }

    override fun disconnect(endpointId: String): Boolean {
        return nearbyManager.disconnect(endpointId)
    }

    override fun sendMessage(
        endpointId: String,
        message: String
    ): Boolean {
        return nearbyManager.sendMessage(endpointId, message)
    }

    override fun sendJson(
        endpointId: String,
        json: String
    ): Boolean {
        return nearbyManager.sendJson(endpointId, json)
    }

}
