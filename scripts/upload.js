const path = require("path")
const fs = require("fs")
const { execSync } = require("child_process")
const {
  uploadToOSS,
  zipLocalFolder,
  getCurrentTimeYYYYMMDDHHhhmmss,
} = require("./utils")

;(async () => {
  const designerPath = path.join(__dirname, "../packages/designer")
 
  execSync(`cd ${designerPath} && npx mybricks build`, { encoding: "utf-8", stdio: "inherit" })

  const packageJson = JSON.parse(fs.readFileSync(path.join(designerPath, "package.json"), "utf-8"))
  const time = getCurrentTimeYYYYMMDDHHhhmmss()
  const folderPath = `comlibs/harmony/${packageJson.name}/${packageJson.version}/${time}`

  const editOSS = await uploadToOSS({
    content: fs.readFileSync(path.join(designerPath, "dist/lib/edit.js"), "utf-8"),
    folderPath,
    fileName: "edit.js",
    noHash: true
  })

  const zipOSS = await uploadToOSS({
    content: zipLocalFolder(path.join(__dirname, "../packages/rt-arkts/comlib/src/main/ets")).toBuffer(),
    folderPath,
    fileName: "comlib.zip",
    noHash: true
  })

  console.log("[将该地址填入应用组件库配置]\n", decodeURIComponent(editOSS))
})()
