require! ['http', 'cluster', './server']
num-cpus = require 'os' .cpus!length

if cluster.is-master
  [cluster.fork! for i in [1 to num-cpus]]

  cluster.on 'exit', (worker, code, signal)!-> cluster.fork!

else
  server.listen port = 3011
console.log "12306+ server is running at #port" 
