allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Fix for namespace issues in plugin modules
subprojects {
    afterEvaluate {
        if (project.hasProperty("android")) {
            val android = project.extensions.findByName("android")
            try {
                if (android != null && android.javaClass.methods.any { it.name == "getNamespace" }) {
                    val getNamespace = android.javaClass.getMethod("getNamespace")
                    val namespace = getNamespace.invoke(android) as String?
                    if (namespace == null || namespace.isEmpty()) {
                        val packageName = project.group.toString()
                        if (packageName.isNotEmpty()) {
                            val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                            setNamespace.invoke(android, packageName)
                            println("Set namespace for ${project.name} to $packageName")
                        } else {
                            println("Warning: Could not set namespace for ${project.name}, empty package name")
                        }
                    }
                }
            } catch (e: Exception) {
                println("Warning: Error setting namespace for ${project.name}: ${e.message}")
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
