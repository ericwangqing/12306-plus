require! ['express', 'http', 'cluster']
num-cpus = require 'os' .cpus!length

if cluster.is-master
  [cluster.fork! for i in [1 to num-cpus]]

  cluster.on 'exit', (worker, code, signal)!-> cluster.fork!

else
  app = express!

  app.get '/', (req, res)!->
    body = 'hello express'
    res.set-header 'Content-Type', 'text/plain'
    res.set-header 'Content-Length', Buffer.byte-length body
    res.end body

  app.listen 3011