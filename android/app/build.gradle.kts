// android/app/build.gradle.kts
plugins {
 id("com.android.application")
 id("kotlin-android")
 id("dev.flutter.flutter-gradle-plugin")
 id("com.google.gms.google-services")
}
android {
 namespace = "com.example.turismo_notificaciones"
 compileSdk = flutter.compileSdkVersion
 ndkVersion = flutter.ndkVersion
 defaultConfig {
 applicationId = "com.example.turismo_notificaciones"
 minSdk = maxOf(21, flutter.minSdkVersion)
 targetSdk = flutter.targetSdkVersion
 versionCode = flutter.versionCode
 versionName = flutter.versionName
 }
 compileOptions {
 sourceCompatibility = JavaVersion.VERSION_17
 targetCompatibility = JavaVersion.VERSION_17
 isCoreLibraryDesugaringEnabled = true
 }
 kotlinOptions { jvmTarget = JavaVersion.VERSION_17.toString() }
}
dependencies {
 coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
