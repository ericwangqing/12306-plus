debug = require('debug')('12306')
module.exports =
  get-uuid: -> Date.now! + Math.random!
