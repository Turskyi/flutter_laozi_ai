@file:Suppress("unused")

package com.turskyi.laozi_ai

import android.util.Log
import com.google.android.gms.tasks.Task
import com.google.android.play.core.appupdate.AppUpdateInfo
import com.google.android.play.core.appupdate.AppUpdateManager
import com.google.android.play.core.appupdate.AppUpdateManagerFactory
import com.google.android.play.core.appupdate.AppUpdateOptions
import com.google.android.play.core.install.model.AppUpdateType
import com.google.android.play.core.install.model.UpdateAvailability
import io.flutter.embedding.android.FlutterActivity

/**
 * [MainActivity] is the main entry point for the Android side of the Flutter
 * application.
 *
 * It includes an implementation of in-app updates using the Play Core library,
 * allowing the app to prompt users to update when a new version is available
 * on the Play Store.
 *
 * This implementation follows the guidelines from the official Android
 * documentation:
 * @see <a href="https://developer.android.com/guide/playcore/in-app-updates">
 *     In-app updates</a>
 */
class MainActivity : FlutterActivity() {
    companion object {
        private const val UPDATE_REQUEST_CODE = 500
    }

    override fun onResume() {
        super.onResume()
        checkAppUpdate()
    }

    private fun checkAppUpdate() {
        val appUpdateManager: AppUpdateManager =
            AppUpdateManagerFactory.create(this)
        val appUpdateInfoTask: Task<AppUpdateInfo> =
            appUpdateManager.appUpdateInfo

        appUpdateInfoTask.addOnSuccessListener { appUpdateInfo: AppUpdateInfo ->
            if (appUpdateInfo.updateAvailability() == UpdateAvailability.UPDATE_AVAILABLE &&
                appUpdateInfo.isUpdateTypeAllowed(
                    AppUpdateType.IMMEDIATE,
                )
            ) {
                try {
                    appUpdateManager.startUpdateFlowForResult(
                        appUpdateInfo,
                        this,
                        AppUpdateOptions.newBuilder(
                            AppUpdateType.IMMEDIATE,
                        )
                            .build(),
                        UPDATE_REQUEST_CODE
                    )
                } catch (e: Exception) {
                    Log.e(
                        "MainActivity",
                        "Failed to start update flow",
                        e,
                    )
                }
            } else if (appUpdateInfo.updateAvailability()
                == UpdateAvailability.DEVELOPER_TRIGGERED_UPDATE_IN_PROGRESS
            ) {
                // If an in-app update is already running, resume the update.
                try {
                    appUpdateManager.startUpdateFlowForResult(
                        appUpdateInfo,
                        this,
                        AppUpdateOptions.newBuilder(
                            AppUpdateType.IMMEDIATE,
                        )
                            .build(),
                        UPDATE_REQUEST_CODE,
                    )
                } catch (e: Exception) {
                    Log.e(
                        "MainActivity",
                        "Failed to resume update flow",
                        e,
                    )
                }
            }
        }
    }
}
