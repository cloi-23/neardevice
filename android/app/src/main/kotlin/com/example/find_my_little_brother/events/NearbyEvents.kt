package com.example.find_my_little_brother.events

import io.flutter.plugin.common.EventChannel

object NearbyEvents {

    var sink: EventChannel.EventSink? = null

    fun connected(
        endpointId: String
    ) {

        sink?.success(
            mapOf(
                "type" to "connected",
                "endpointId" to endpointId
            )
        )

    }

    fun disconnected(
        endpointId: String
    ) {

        sink?.success(
            mapOf(
                "type" to "disconnected",
                "endpointId" to endpointId
            )
        )

    }

    fun textReceived(
        endpointId: String,
        message: String
    ) {

        sink?.success(
            mapOf(
                "type" to "text_received",
                "endpointId" to endpointId,
                "message" to message
            )
        )

    }

    fun jsonReceived(
        endpointId: String,
        json: String
    ) {

        sink?.success(
            mapOf(
                "type" to "json_received",
                "endpointId" to endpointId,
                "json" to json
            )
        )

    }

    fun deviceFound(
        endpointId: String,
        endpointName: String
    ) {

        sink?.success(
            mapOf(
                "type" to "device_found",
                "endpointId" to endpointId,
                "endpointName" to endpointName
            )
        )

    }

    fun deviceLost(
        endpointId: String
    ) {

        sink?.success(
            mapOf(
                "type" to "device_lost",
                "endpointId" to endpointId
            )
        )

    }
}
