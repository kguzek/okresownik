plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

import java.util.Properties

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}

android {
    namespace = "uk.guzek.okresownik"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "uk.guzek.okresownik"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    val releaseKeystorePath = System.getenv("KEYSTORE_PATH") ?: keystoreProperties.getProperty("storeFile")
    val hasReleaseKeystore = !releaseKeystorePath.isNullOrBlank()

    if (hasReleaseKeystore) {
        signingConfigs {
            create("release") {
                storeFile = file(releaseKeystorePath)
                storePassword = System.getenv("KEYSTORE_PASSWORD") ?: keystoreProperties.getProperty("storePassword") ?: ""
                keyAlias = System.getenv("KEY_ALIAS") ?: keystoreProperties.getProperty("keyAlias") ?: ""
                keyPassword = System.getenv("KEY_PASSWORD") ?: keystoreProperties.getProperty("keyPassword") ?: ""
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (hasReleaseKeystore) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
