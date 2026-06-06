package sn.lic.beauteavenu

import org.junit.Test
import org.junit.runner.RunWith
import androidx.test.ext.junit.runners.AndroidJUnit4

/**
 * Patrol Android test entry point.
 *
 * The testInstrumentationRunner in build.gradle.kts is
 * pl.leancode.patrol.PatrolJUnitRunner, which extends AndroidJUnitRunner.
 * This runner intercepts test execution and coordinates with the Dart
 * test bundle (test_bundle.dart) via the Patrol Flutter plugin.
 *
 * This empty test class ensures the androidTest APK has at least one
 * test class, which is required for the instrumentation runner to activate.
 */
@RunWith(AndroidJUnit4::class)
class MainActivityTest {

    @Test
    fun patrolTestBundle() {
        // Patrol's instrumentation runner handles test discovery
        // and Dart test execution automatically.
    }
}
