package com.example.find_my_little_brother.services

data class NearbyDevice(
    val endpointId: String,
    val endpointName: String
)

object NearbyRepository {

    private val devices =
        mutableMapOf<String, NearbyDevice>()

    fun add(device: NearbyDevice) {
        devices[device.endpointId] = device
    }

    fun remove(endpointId: String) {
        devices.remove(endpointId)
    }

    fun all(): List<NearbyDevice> {
        return devices.values.toList()
    }

    fun find(endpointId: String): NearbyDevice? {
        return devices[endpointId]
    }
}