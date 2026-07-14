package com.example.find_my_little_brother.services

import android.os.Build

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
}