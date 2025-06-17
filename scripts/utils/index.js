const zip = require("./zip")
const time = require("./time")
const upload = require("./upload")

module.exports ={
  ...zip,
  ...time,
  ...upload
}