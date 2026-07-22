package com.example.find_my_little_brother.services

import android.content.Context
import android.os.Build
import android.provider.Settings

object DeviceInfoService {

    fun getDeviceName(): String {

        val manufacturer = Build.MANUFACTURER.trim()
        val model = Build.MODEL.trim()

        return if (model.startsWith(manufacturer, ignoreCase = true)) {
            model
        } else {
            "$manufacturer $model"
        }
    }

    fun getDeviceId(context: Context): String {
        return Settings.Secure.getString(
            context.contentResolver,
            Settings.Secure.ANDROID_ID
        )
    }
}
