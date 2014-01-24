require! ['express']

app = express!
Redis-store = (require 'connect-redis') express
redis = require 'redis' .create-client!

app.configure ->
  app.use express.logger 'dev'
  app.use express.body-parser!
  app.use express.method-override!
  app.use express.cookie-parser!
  app.use express.session config =
    secret: '12306+ is reallly awsome'
    store: new Redis-store {host: 'localhost', client: redis}

app.get '/', (req, res)!->
  body = 'hello expres thisddffd it'
  # res.set-header 'Content-Type', 'text/plain'
  # res.set-header 'Content-Length', Buffer.byte-length body
  # res.end body
  if not req.session.test
    req.session.test ||= 0
    req.session.test++
  # console.log "test value is: #{req.session.test}"
  res.send body


module.exports = app
