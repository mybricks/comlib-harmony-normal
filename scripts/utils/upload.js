const axios = require("axios")
const FormData = require('form-data');

async function uploadToOSS({content, folderPath, fileName, noHash}) {
  const blob = Buffer.from(content)
  const formData = new FormData()
  formData.append("file", blob, fileName)
  formData.append("fileName", fileName)
  formData.append("folderPath", folderPath)
  formData.append("noHash", JSON.stringify(noHash))
  
  try {
    const res = await axios.post("https://my.mybricks.world/paas/api/oss/uploadFile", formData)
    const { code, data } = res.data
    if (code === 1) {
      return data.url
    } else {
      throw new Error(res)
    }
  } catch (err) {
    throw new Error(err)
  }
}

module.exports = {
  uploadToOSS
}
