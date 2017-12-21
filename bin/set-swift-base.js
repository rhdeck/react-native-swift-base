#!/usr/bin/env node
var pbxproj = require("xcode");
var fs = require("fs");
var path = require("path");
var glob = require("glob");
//Get my directory
const binFile = process.argv[1];
const binPath = path.dirname(binFile); //bin directory
const modulePath = path.dirname(binPath); //dependency directory
var node_modulesPath = path.dirname(modulePath); // node_modules
var baseName = path.basename(node_modulesPath);
if (!baseName.startsWith("node_modules")) {
  console.log("This is not a dependency: ", thisPath);
  process.exit();
}
var projectPath = path.dirname(node_modulesPath); // parent
var iosPath = path.join(projectPath, "ios");
if (!fs.existsSync(iosPath)) {
  console.log("Could not find ios in ", projectPath, iosPath);
  console.log(fs.readdirSync(projectPath));
  process.exit();
}
xpdir = glob.sync(path.join(iosPath, "*.xcodeproj"))[0];
if (xpdir.length === 0) {
  console.log("Could not find xcodeproj directory inside: ", iosPath);
  process.exit();
}
const appDelegateName = "AppDelegate.swift";
const bridgingHeaderName = "swift-Bridging-Header.h";
let filename = path.join(xpdir, "project.pbxproj");
let properties = {
  SWIFT_VERSION: "4.0",
  SWIFT_OBJC_BRIDGING_HEADER: bridgingHeaderName
};
if (!fs.existsSync(filename)) {
  console.log("Could not find pbxproj file:", filename);
  process.exit();
}

const appDelegateTargetPath = path.join(iosPath, appDelegateName);
const bridgingHeaderTargetPath = path.join(iosPath, bridgingHeaderName);

//Reason check - are they already here?
if (fs.existsSync(appDelegateTargetPath)) {
  console.log(appDelegateName + " is already in " + iosPath + ": aborting");
  process.exit(1);
}

const templatesPath = path.join(modulePath, "templates");

const appDelegateSourcePath = path.join(templatesPath, appDelegateName);
const bridgingHeaderSourcePath = path.join(templatesPath, bridgingHeaderName);

fs.copyFileSync(appDelegateSourcePath, appDelegateTargetPath);
fs.copyFileSync(bridgingHeaderSourcePath, bridgingHeaderTargetPath);

const removes = ["AppDelegate.h", "AppDelegate.m", "main.m"];
const adds = {};
adds[appDelegateName] = appDelegateTargetPath;
adds[bridgingHeaderName] = bridgingHeaderTargetPath;

var proj = pbxproj.project(filename);
proj.parse(function(err) {
  const fp = proj.getFirstProject();
  Object.keys(adds).forEach(fileName => {
    const path = adds[fileName];
    let file = proj.addFile(path, null, fp);
    if (!file) {
      console.log("Looks like the file is already here - aborting", fileName);
      return;
    }
    file.uuid = this.generateUuid();
    const nts = proj.pbxNativeTargetSection();
    for (var key in nts) {
      if (key.endsWith("_comment")) continue;
      const target = proj.pbxTargetByName(nts[key].name);
      file.target = key;
      proj.addToPbxBuildFileSection(file); // PBXBuildFile
      proj.addToPbxSourcesBuildPhase(file);
    }
  });
  removes.forEach(key => {
    proj.removeSourceFile(key, null, fp);
  });
  Object.keys(properties).forEach(key => {
    proj.addBuildProperty(key, properties[key]);
  });
  const out = proj.writeSync();
  fs.writeFileSync(filename, out);
});
