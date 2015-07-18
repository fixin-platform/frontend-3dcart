var description = {
  summary: "Frontend 3DCart",
  version: "1.0.0",
  name: "frontend-3dcart"
};
Package.describe(description);

var path = Npm.require("path");
var fs = Npm.require("fs");
eval(fs.readFileSync("./packages/autopackage.js").toString());
Package.onUse(function(api) {
  addFiles(api, description.name, getDefaultProfiles());
  api.use(["frontend-core"]);
});
