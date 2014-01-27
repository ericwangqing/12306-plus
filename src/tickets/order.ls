require! ['./Database']
db = Database.get!db

class Order
  @make-an-order = (request, callback)->
    (err, value) <-! db.get '__test'
    console.log "get value is: #value"
    if value
      callback null, value
    else
      (err, result) <-! db.set '__test', value = Math.random!
      console.log "value is: #value"
      callback null, result: value
    # db.set '__test', Math.random! if not db.get '__test'
    # value = db.get '__test'
    # callback null, db.get '__test'

  @get-order = (order-id, callback)->

    (@user-id, @state, @tickets)->



module.exports = Order
