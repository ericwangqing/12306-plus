require! 'express'
app = express!

app.get '/', (req, res)!->
  body = 'hello express'
  res.set-header 'Content-Type', 'text/plain'
  res.set-header 'Content-Length', Buffer.byte-length body
  res.end body

app.listen 3010 