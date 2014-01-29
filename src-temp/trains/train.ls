debug = require('debug')('12306')
require! ['./Database']
db = Database.get!

class Train
  @get-mask-for-travel = (train-no, departure, destination, callback)!->
    debug "______________ddfd-_________________"
    train-mask-key = db.get-key 'travel-masks', train-no, departure, destination
    db.store.get train-mask-key, callback

module.exports = Train