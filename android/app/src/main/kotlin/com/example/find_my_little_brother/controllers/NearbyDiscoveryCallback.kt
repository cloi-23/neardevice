package com.example.find_my_little_brother.controllers

import com.example.find_my_little_brother.events.NearbyEvents
import android.util.Log
import com.example.find_my_little_brother.services.NearbyDevice
import com.example.find_my_little_brother.services.NearbyRepository
import com.google.android.gms.nearby.connection.DiscoveredEndpointInfo
import com.google.android.gms.nearby.connection.EndpointDiscoveryCallback

class NearbyDiscoveryCallback : EndpointDiscoveryCallback() {

    companion object {
        private const val TAG = "NearbyDiscovery"
    }

    override fun onEndpointFound(
        endpointId: String,
        info: DiscoveredEndpointInfo
    ) {

        NearbyRepository.add(
            NearbyDevice(
                endpointId = endpointId,
                endpointName = info.endpointName
            )
        )

        NearbyEvents.deviceFound(
            endpointId,
            info.endpointName
        )  

        Log.d(
            TAG,
            "FOUND -> ${info.endpointName} ($endpointId)"
        )

        Log.d(
            TAG,
            "Devices = ${NearbyRepository.all().size}"
        )
    }

    override fun onEndpointLost(
        endpointId: String
    ) {
        NearbyEvents.deviceLost(
            endpointId
        )        

        NearbyRepository.remove(endpointId)

        Log.d(
            TAG,
            "LOST -> $endpointId"
        )

        Log.d(
            TAG,
            "Devices = ${NearbyRepository.all().size}"
        )
    }
}