const plist = require("plist");
const fs = require("fs");
const path = require("path");
const hexrgb = require("hex-rgb");
const rgbhex = require("rgb-hex");
const glob = require("glob");

module.exports = hexcolor => {
  const rawObj = hexrgb(hexcolor);
  colorObj = {
    red: parseFloat(rawObj.red) / 255.0,
    blue: parseFloat(rawObj.blue) / 255.0,
    green: parseFloat(rawObj.green) / 255.0,
    alpha: parseFloat(rawObj.alpha) / 255.0
  };
  const plistpaths = glob.sync(
    path.join(process.cwd(), "ios", "*", "Info.plist")
  );
  plistpaths.forEach(plistpath => {
    const txt = fs.readFileSync(plistpath, { encoding: "utf8" });
    const p = plist.parse(txt);
    p.backgroundColor = colorObj;
    const xml = plist.build(p);
    fs.writeFileSync(plistpath, xml);
  });
};
