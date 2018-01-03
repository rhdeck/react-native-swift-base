const plist = require("plist");
const fs = require("fs");
const path = require("path");
const inquirer = require("inquirer");
const hexrgb = require("hex-rgb");
const rgbhex = require("rgb-hex");

module.exports = [
  {
    name: "bgcolor [newcolor]",
    description: "Set background color for application",
    func: newcolor => {
      if (typeof newcolor !== "string") {
        newcolor = newcolor[0];
      }
      const pp = path.join(process.cwd(), "package.json");
      const p = require(pp);
      if (typeof newcolor !== "undefined") {
        p.backgroundColor = newcolor;
        fs.writeFileSync(pp, JSON.stringify(p, null, 2));
        require("../lib/setPListColor")();
        console.log("Saved and applied color", newcolor);
        return;
      }
      defColor = "";
      if (p.backgroundColor) {
        defColor = p.backgroundColor;
      }

      inquirer
        .prompt({
          name: "bgcolor",
          message:
            "What color do you want for your default background? (as Hex value)",
          default: defColor,
          validate: answer => {
            return hexrgb(answer);
          }
        })
        .then(answers => {
          p.backgroundColor = answers.bgcolor;
          fs.writeFileSync(pp, JSON.stringify(p, null, 2));
          require("../lib/setPListColor")();
          console.log("Updated background color", answers.bgcolor);
        });
    }
  }
];
