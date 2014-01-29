debug = require('debug')('12306')
require! ['./Database', './Ticket', './utils']
_ = require 'underscore'
db = Database.get!

class Order
  @make-an-order = (request, uid, callback)->
    (err, order) <-! @create request, uid
    (err, tickets-result) <-! Ticket.reserve-tickets order
    if tickets-result.is-success
      order.state = 'reserved'
      <-! order.save 
      (err, pub-result) <-! Ticket.pub-remaind-tickets tickets-result
      (err, seats-result) <-! Ticket.assign-seats order
      order.state = 'seats-assigned'
      <-! order.save
      callback null, seats-result
    else
      order.state = 'failed'
      <-! order.save
      callback null, {is-success: false}

    (err, result) <-! User.save-order order

  @create = (request, uid, callback)->
    debug "request is: ", request
    user-id = uid
    state = 'pending' # pending | all-reserved | (n/m)-reserved | failed | seats-assigned
    order = new @ user-id, state, _.pick request, 'departure', 'destination', 'trainNo', 'day', 'ticketType', 'ticketClass'
    (err, result) <-! order.save
    user-orders-key = db.get-key 'user-orders', user-id
    (err, result) <-! db.store.lpush user-orders-key, order.key
    debug "11order: ", order
    callback null, order

  # @parse-tickets

  @get-order = (order-id, callback)->

  (@user-id, @state, ticket-description)->
    _.extend @, ticket-description
    @id = utils.get-uuid!
    @date = Date.now!

  save: (callback)->
    db.store.set (db.get-key 'orders', @id), @, callback






module.exports = Order
