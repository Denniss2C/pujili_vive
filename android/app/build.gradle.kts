import java.io.FileInputStream
import java.util.Properties

val localProperties = Properties()
rootProject.file("local.properties").takeIf { it.exists() }?.let { file ->
    FileInputStream(file).use { localProperties.load(it) }
}
val mapsApiKey: String = localProperties.getProperty("MAPS_API_KEY") ?: ""

// Firma de release. `key.properties` esta gitignorado y no llega con un
// clone, asi que la config es OPCIONAL: quien no lo tenga sigue pudiendo
// compilar release (firmado con debug) y el build no se rompe para nadie.
// Ver docs/RELEASE_ANDROID.md.
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
val hasReleaseKeystore = keystorePropertiesFile.exists()
if (hasReleaseKeystore) {
    FileInputStream(keystorePropertiesFile).use { keystoreProperties.load(it) }
}

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "ec.gob.pujili.pujili_vive"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "ec.gob.pujili.pujili_vive"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["MAPS_API_KEY"] = mapsApiKey
    }

    // AGP 8 trae la feature resValues DESACTIVADA por defecto, y sin
    // ella el resValue de los flavors falla con "Product Flavor dev
    // contains custom resource values, but the feature is disabled".
    buildFeatures {
        resValues = true
    }

    // Ambientes dev/prod. Con esto, `flutter run`/`build` SIEMPRE
    // requieren --flavor dev|prod. dev usa un applicationId con sufijo
    // .dev para poder instalarse junto a prod en el mismo dispositivo.
    flavorDimensions += "env"
    productFlavors {
        create("dev") {
            dimension = "env"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            // El nombre del lanzador se genera aqui, no en un res/ por
            // flavor: asi dev y prod se distinguen en el cajon de apps
            // sin duplicar carpetas de recursos.
            resValue("string", "app_name", "Pujili Vive Dev")
        }
        create("prod") {
            dimension = "env"
            resValue("string", "app_name", "Pujili Vive")
        }
    }

    signingConfigs {
        if (hasReleaseKeystore) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            // Sin key.properties cae a debug para no romper a quien no
            // tenga el keystore. OJO: un AAB firmado con debug lo
            // rechaza Play Store; verificar con keytool antes de subir.
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
