## singlton 
redis = require 'redis'

class Database
  @instance = null

  @get = ->
    @instance = new @ if @instance is null
    @instance

  ->
    @db = redis.create-client!

module.exports = Database