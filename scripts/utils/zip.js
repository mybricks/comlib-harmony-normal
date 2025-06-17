const AdmZip = require("adm-zip");

function zipLocalFolder(folderPath) {
  const zip = new AdmZip()

  zip.addLocalFolder(folderPath)

  return zip
}

module.exports = {
  zipLocalFolder
}
