allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

fun configureAndroidNamespace(project: Project) {
    val android = project.extensions.findByName("android") as? com.android.build.gradle.BaseExtension ?: return
    if (android.namespace == null) {
        when (project.name) {
            "isar_flutter_libs" -> android.namespace = "io.isar.isar_flutter_libs"
            "flutter_inappwebview" -> android.namespace = "com.pichillilorenzo.flutter_inappwebview"
            else -> android.namespace = "io.flutter.plugins." + project.name.replace("-", ".")
        }
    }
}

subprojects {
    plugins.withType(com.android.build.gradle.internal.plugins.AppPlugin::class.java) {
        configureAndroidNamespace(project)
    }
    plugins.withType(com.android.build.gradle.LibraryPlugin::class.java) {
        configureAndroidNamespace(project)
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
