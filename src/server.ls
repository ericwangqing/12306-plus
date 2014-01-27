## 12306+ REST Server 12306+ 的动态数据均以Ajax的方式由REST Server提供。

require! ['express', './Database', './Order']

app = express!
Redis-store = (require 'connect-redis') express
redis = Database.get!db

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
  console.log "req id: ", req.body.id
  (error, result) <- Order.make-an-order req
  res.json 500, error if error
  if not req.session.test
    req.session.test ||= 0
    req.session.test++
  res.json 200, result

app.get '/', (req, res)!->
  body = 'hello expres thisddffd it'
  if not req.session.test
    req.session.test ||= 0
    req.session.test++
  # console.log "test value is: #{req.session.test}"
  res.send body


module.exports = app
