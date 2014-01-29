debug = require('debug')('12306')
## 12306+ REST Server 12306+ 的动态数据均以Ajax的方式由REST Server提供。

require! ['express', './Database', './Order']

_server = null # http server returned by listen

DEFAULT_DEV_PORT = 3010
app = express!
Redis-store = (require 'connect-redis') express
redis = Database.get!store

app.configure ->
  # app.use express.logger 'dev'
  # app.use express.body-parser!
  # app.use express.method-override!
  # app.use express.json!
  # app.use express.urlencoded!
  app.use express.cookie-parser!
  app.use express.json!
  app.use express.session config =
    secret: '12306+ is reallly awsome'
    store: new Redis-store {host: 'localhost', client: redis} # 注意：优化性能时，如果一台服务器的性能已经可以应对需求，可改为直接用session in memory


app.post '/orders', (req, res)!->
  # res.json 200, {"a": "1"}
  debug "req: ", req.body
  uid = 'FAKE_TESTING_USER' if req.body.is-test
  (error, result) <- Order.make-an-order req.body, uid
  debug 'to send response: ', result
  res.json 500, error if error
  res.json 200, result
  debug 'sent response: ', result

app.get '/', (req, res)!->
  body = 'hello expres thisddffd it'
  if not req.session.test
    req.session.test ||= 0
    req.session.test++
  # console.log "test value is: #{req.session.test}"
  res.send body


module.exports = 
  app: app # for testing
  start: (port, done)!->
    done = port if typeof done is 'undefined' and typeof port is 'function'
    port = DEFAULT_DEV_PORT if typeof port isnt 'number'
    _server := app.listen port = port, ->
      console.info "\n**************** server listen at #port ***************"
      done! if done

  shutdown: !->
    console.info "****************** close server **********************\n" 
    _server.close! 
