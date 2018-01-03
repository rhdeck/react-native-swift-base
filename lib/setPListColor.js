const path = require("path");
const fs = require("fs");
const setBGColor = require("./setBGColor.js");
module.exports = () => {
  //Get bg color
  const pp = path.join(process.cwd(), "package.json");
  if (fs.existsSync(pp)) {
    const p = require(pp);
    if (p.backgroundColor) {
      if (setBGColor(p.backgroundColor)) {
        console.log("Updated background color");
      }
    }
  }
};
