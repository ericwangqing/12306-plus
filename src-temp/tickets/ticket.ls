debug = require('debug')('12306')
require! ['./Database', './Train']
_ = require 'underscore'
db = Database.get!

class Ticket
  @reserve-tickets = (order, callback)!->
    coded-remaind-tickets-key = @get-coded-remaind-tickets-key order
    (err, coded-remaind-tickets) <~! db.store.get coded-remaind-tickets-key
    coded-remaind-tickets = [parse-int token for token in coded-remaind-tickets.split ',']
    debugger
    (err, coded-mask) <~! Train.get-mask-for-travel order.train-no, order.departure, order.destination
    mask = [parse-int token for token in coded-mask.split ',']
    # TODO：注意！！！这里在多进程时，需要sync保护
    debug "mask: ", mask
    if @can-order coded-remaind-tickets, mask
      @update-coded-remaind-tickets coded-remaind-tickets, mask
      (err, result) <-! db.store.set coded-remaind-tickets-key, coded-remaind-tickets
      callback null, {is-success: true, train-ticket-key: coded-remaind-tickets-key, coded-remaind-tickets: coded-remaind-tickets}
    else
      callback null, {is-success: false}

  @get-coded-remaind-tickets-key = (order)->
    debug "order: ", order
    db.get-key 'remaind-tickets', order.train-no, order.day, order.ticket-type, order.ticket-class

  @can-order = (coded-remaind-tickets, mask)->
    for remaind-tickets, i in coded-remaind-tickets
      return false if remaind-tickets - mask[i] < 0
    true

  @update-coded-remaind-tickets = (coded-remaind-tickets, mask)!->
    for remaind-tickets, i in coded-remaind-tickets
      coded-remaind-tickets[i] -=  mask[i]

  @pub-remaind-tickets = (tickets-result, callback)->
    # TODO
    # console.log "pub-remaind-tickets UNIMPLEMENTED!! tickets-result: ", tickets-result
    callback null, null


  @assign-seats = (order, callback)!->
    # console.log "assign-seats UNIMPLEMENTED!!  "
    callback null, {is-success: true}






module.exports = Ticket