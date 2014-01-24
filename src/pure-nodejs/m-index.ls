require! ['http', 'cluster']
num-cpus = require 'os' .cpus!length

if cluster.is-master
  [cluster.fork! for i in [1 to num-cpus]]

  cluster.on 'exit', (worker, code, signal)!-> cluster.fork!

else
  http.create-server (req, res)!->
    res.write-head 200, 'Content-Type': 'text/plain'
    res.write 'hello world'
    res.end!
  .listen 4011