package com.example.find_my_little_brother.controllers

import android.util.Log
import com.example.find_my_little_brother.events.NearbyEvents
import com.google.android.gms.nearby.connection.ConnectionsClient
import com.google.android.gms.nearby.connection.Payload
import com.google.android.gms.nearby.connection.PayloadCallback
import com.google.android.gms.nearby.connection.PayloadTransferUpdate
import org.json.JSONArray
import org.json.JSONObject
import org.json.JSONTokener

class PayloadController(
    private val client: ConnectionsClient
) {

    companion object {
        private const val TAG = "PayloadController"
    }

    val callback = object : PayloadCallback() {
        override fun onPayloadReceived(
            endpointId: String,
            payload: Payload
        ) {
            if (payload.type != Payload.Type.BYTES) {
                Log.d(TAG, "Ignoring non-text payload from $endpointId")
                return
            }

            val message = payload.asBytes()?.toString(Charsets.UTF_8)

            if (message == null) {
                Log.e(TAG, "Received an empty text payload from $endpointId")
                return
            }

            if (isValidJson(message)) {
                Log.d(TAG, "JSON received from $endpointId: $message")
                NearbyEvents.jsonReceived(endpointId, message)
            } else {
                Log.d(TAG, "Text received from $endpointId: $message")
                NearbyEvents.textReceived(endpointId, message)
            }
        }

        override fun onPayloadTransferUpdate(
            endpointId: String,
            update: PayloadTransferUpdate
        ) {
            Log.d(TAG, "Payload transfer update from $endpointId: ${update.status}")
        }
    }

    fun sendTextPayload(
        endpointId: String,
        message: String
    ): Boolean {
        if (message.isBlank()) {
            Log.w(TAG, "Refusing to send an empty text payload")
            return false
        }

        client.sendPayload(
            endpointId,
            Payload.fromBytes(message.toByteArray(Charsets.UTF_8))
        )
            .addOnSuccessListener {
                Log.d(TAG, "Text sent to $endpointId: $message")
            }
            .addOnFailureListener {
                Log.e(TAG, "Failed to send text to $endpointId", it)
            }

        return true
    }

    fun sendJsonPayload(
        endpointId: String,
        json: String
    ): Boolean {
        if (!isValidJson(json)) {
            Log.w(TAG, "Refusing to send invalid JSON")
            return false
        }

        return sendBytesPayload(endpointId, json, "JSON")
    }

    private fun sendBytesPayload(
        endpointId: String,
        content: String,
        contentType: String
    ): Boolean {
        client.sendPayload(
            endpointId,
            Payload.fromBytes(content.toByteArray(Charsets.UTF_8))
        )
            .addOnSuccessListener {
                Log.d(TAG, "$contentType sent to $endpointId: $content")
            }
            .addOnFailureListener {
                Log.e(TAG, "Failed to send $contentType to $endpointId", it)
            }

        return true
    }

    private fun isValidJson(value: String): Boolean {
        return try {
            when (JSONTokener(value).nextValue()) {
                is JSONObject,
                is JSONArray -> true
                else -> false
            }
        } catch (_: Exception) {
            false
        }
    }
}
