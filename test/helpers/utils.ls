require! {async, '../bin/database', 'http'}
debug = require('debug')('12306')
_ = require 'underscore'

FIXTURE_PATH = __dirname + '/../test-bin/' # 这样写，是因为在开发时，src目录中的代码也会使用。

#------------------- Utility Classes ------------------#
class All-done-waiter
  !(@done)->
    @running-functions = 0

  set-done: (done)~>
    @done = done

  add-waiting-function: (fn)~>
    @running-functions += 1
    !~>
      fn.apply null, arguments if fn
      @running-functions -= 1
      @check!

  check: !~>
    @done! if @running-functions is 0

#------------------- Utility Functions ------------------# 

load-fixture = (data-name)->
  eval require('fs').readFileSync(FIXTURE_PATH + data-name + '.js', {encoding: 'utf-8'}) 


open-clean-db-and-load-fixtures = (config, done)!->
  store = database.get!store
  store.flushdb!
  datanames = _.keys config
  async.each datanames, (dataname, next)!->
    async.each (_.values config[dataname]), (key-values, _next)!->
      async.each (_.keys key-values), (key, __next)!->
        (err, docs) <-! store.set key, value = key-values[key]
        console.log 'error: ', err if err
        # debug "key: #key, value: #value"
        __next!
      , ->
        _next!
    , ->
      next!
  , ->
    done!


prepare-clean-test-db = (done)!->
  open-clean-db-and-load-fixtures {
    '京九线': load-fixture "京九线"
  }, done

close-db = (done)!->
  store = database.get!store
  store.quit!

# post = (path, data, callback)!->
#   content = JSON.stringify data
#   options =
#     hostname: 'localhost'
#     port: '3010'
#     path: path
#     method: 'POST'
#     headers:
#       'Content-Type': 'application/json'
#       'Content-Length': content.length
#   request = http.request options, (response)!->
#     response.set-encoding 'utf8'
#     response.on 'data', (chunk)!->
#       debug 'RESPONSE BODY: ', chunk
#       callback chunk

#   request.on 'error', (e)!->
#     debug 'problem with request: ', e.message

#   request.write content
#   request.end!

module.exports =
  All-done-waiter: All-done-waiter
  load-fixture: load-fixture
  open-clean-db-and-load-fixtures: open-clean-db-and-load-fixtures
  prepare-clean-test-db: prepare-clean-test-db
  close-db: close-db
  # post: post
