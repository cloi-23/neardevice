package com.example.find_my_little_brother

import com.example.find_my_little_brother.events.NearbyEvents
import com.example.find_my_little_brother.generated.NearbyBridge
import com.example.find_my_little_brother.plugin.NearbyPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity : FlutterActivity() {

    companion object {
        private const val EVENTS_CHANNEL =
            "find_my_little_brother/events"
    }

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine
    ) {

        super.configureFlutterEngine(flutterEngine)

        NearbyBridge.setUp(
            flutterEngine.dartExecutor.binaryMessenger,
            NearbyPlugin(this)
        )

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            EVENTS_CHANNEL
        ).setStreamHandler(

            object : EventChannel.StreamHandler {

                override fun onListen(
                    arguments: Any?,
                    events: EventChannel.EventSink
                ) {

                    NearbyEvents.sink = events

                }

                override fun onCancel(
                    arguments: Any?
                ) {

                    NearbyEvents.sink = null

                }

            }

        )

    }

}