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
    var gradleBuildFile = 'build.gradle'
    var gradleSeparator = '// -------------------- 以上三个库是必须依赖的 ----------------------------'
    var newrelicGradleConf = [
    "",
    "dependencies {",  
      "compile 'com.meiqia:meiqiasdk:3.3.5@aar'",
      "compile 'com.android.support:support-v4:23.1.1'",
      "compile 'com.squareup.okhttp3:okhttp:3.3.1'",
      "compile 'com.nostra13.universalimageloader:universal-image-loader:1.9.5'",
    "}",
    ""
    ].join("\n")

    if (['after_plugin_add', 'after_plugin_install'].indexOf(context.hook) === -1) {
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
        // Add NewRelic Gradle Hooks
        fs.appendFileSync(path.join(androidProjectRoot, gradleBuildFile), gradleSeparator);
        fs.appendFileSync(path.join(androidProjectRoot, gradleBuildFile), newrelicGradleConf);
        fs.appendFileSync(path.join(androidProjectRoot, gradleBuildFile), gradleSeparator);
    }
};