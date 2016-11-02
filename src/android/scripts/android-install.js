#!/usr/bin/env node

module.exports = function (context) {
    var path        = context.requireCordovaModule('path'),
        fs          = context.requireCordovaModule('fs'),
        shell       = context.requireCordovaModule('shelljs'),
        projectRoot = context.opts.projectRoot,
        plugins     = context.opts.plugins || [];

    // The plugins array will be empty during platform add
    if (plugins.length > 0 && plugins.indexOf('haishang-plugin') === -1) {
        return ;
    }

    var ConfigParser = null;
    try {
        ConfigParser = context.requireCordovaModule('cordova-common').ConfigParser;
    } catch(e) {
        // fallback
        ConfigParser = context.requireCordovaModule('cordova-lib/src/configparser/ConfigParser');
    }

    var config      = new ConfigParser(path.join(context.opts.projectRoot, "config.xml")),
        packageName = config.android_packageName() || config.packageName();

    // replace dash (-) with underscore (_)
    packageName = packageName.replace(/-/g , "_");

    console.info("Running android-install.Hook: " + context.hook + ", Package: " + packageName + ", Path: " + projectRoot + ".");

    if (!packageName) {
        console.error("Package name could not be found!");
        return ;
    }

    // android platform available?
    if (context.opts.cordova.platforms.indexOf("android") === -1) {
        console.info("Android platform has not been added.");
        return ;
    }

    var targetDir  = path.join(projectRoot, "platforms", "android", "src", packageName.replace(/\./g, path.sep));
    var androidProjectRoot = path.join(projectRoot, "platforms", "android");
    var importLine = 'import com.newrelic.agent.android.NewRelic; // haishang-cordova injected'
    var startupLine = 'NewRelic.withApplicationToken("AAa45cff1d2cd9dc38e02c8eaa3a3fbef6c040bb7a").start(this.getApplication()); // haishang-cordova injected'
    var mainActivityFile = 'MainActivity.java'
    var gradleBuildFile = 'build.gradle'
    var gradleSeparator = '// HAISHANG-CORDOVA-INJECT'
    var newrelicGradleConf = "\n \
    buildscript { \n\
      repositories { \n\
          mavenCentral() \n\
      } \n\
      dependencies { \n\
          classpath 'com.newrelic.agent.android:agent-gradle-plugin:5.+' \n\
      } \n\
    } \n\
    repositories { \n\
        mavenCentral() \n\
    } \n\
    apply plugin: 'android' \n\
    apply plugin: 'newrelic' \n\
    dependencies { \n\
        compile 'com.newrelic.agent.android:android-agent:5.+' \n\
    } \n"

    var importHook = "import org.apache.cordova.*;"
    var onCreateHook = "super.onCreate(savedInstanceState);"

    if (['after_plugin_add', 'after_plugin_install'].indexOf(context.hook) === -1) {
        // Remove MainActivity Hooks
        fs.readFile(path.join(targetDir, mainActivityFile), 'utf8', function (err,data) {
          if (err) {
            return console.log(err);
          }

          var result = data.replace(importLine, '');
          result = result.replace(startupLine, '');

          fs.writeFile(path.join(targetDir, mainActivityFile), result, 'utf8', function (err) {
            if (err) return console.log(err);
          });
        });

        // Remove Grandle Hooks
        var gradleLines = fs.readFileSync(path.join(androidProjectRoot, gradleBuildFile)).toString().split('\n');
        fs.truncateSync(path.join(androidProjectRoot, gradleBuildFile))
        var hitSeparator = false;
        gradleLines.forEach(function (line) {
            if(line.toString().trim() === gradleSeparator.trim()) {
              hitSeparator = !hitSeparator
            }
            if(!hitSeparator && line.toString().trim() !== gradleSeparator.trim()) {
              fs.appendFileSync(path.join(androidProjectRoot, gradleBuildFile), line.toString() + "\n");
            }
        });


    } else {

        // Add MainActivity Hooks
        fs.readFile(path.join(targetDir, mainActivityFile), 'utf8', function (err,data) {
          if (err) {
            return console.log(err);
          }

          var result = data.replace(importHook, importHook+"\n"+importLine);
          var result = data.replace(importHook, importHook+"\n"+importLine);
              result = result.replace(onCreateHook, onCreateHook+'\n        '+ startupLine);

          fs.writeFile(path.join(targetDir, mainActivityFile), result, 'utf8', function (err) {
            if (err) return console.log(err);
          });
        });

        // Add NewRelic Gradle Hooks
        fs.appendFileSync(path.join(androidProjectRoot, gradleBuildFile), gradleSeparator);
        fs.appendFileSync(path.join(androidProjectRoot, gradleBuildFile), newrelicGradleConf);
        fs.appendFileSync(path.join(androidProjectRoot, gradleBuildFile), gradleSeparator);
    }
};