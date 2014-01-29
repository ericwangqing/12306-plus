debug = require('debug')('12306')
## singlton 
redis = require 'redis'

class Database
  @instance = null

  @get = ->
    @instance = new @ if @instance is null
    @instance

  ->
    @store = redis.create-client!

  get-key: (...tokens)->
    result = tokens.join ':'
    debug "get-key: ", result
    result

module.exports = Database