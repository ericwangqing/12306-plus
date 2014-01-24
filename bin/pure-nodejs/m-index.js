(function(){
  var http, cluster, numCpus, i$, ref$, len$, i;
  http = require('http');
  cluster = require('cluster');
  numCpus = require('os').cpus().length;
  if (cluster.isMaster) {
    for (i$ = 0, len$ = (ref$ = (fn$())).length; i$ < len$; ++i$) {
      i = ref$[i$];
      cluster.fork();
    }
    cluster.on('exit', function(worker, code, signal){
      cluster.fork();
    });
  } else {
    http.createServer(function(req, res){
      res.writeHead(200, {
        'Content-Type': 'text/plain'
      });
      res.write('hello world');
      res.end();
    }).listen(4011);
  }
  function fn$(){
    var i$, to$, results$ = [];
    for (i$ = 1, to$ = numCpus; i$ <= to$; ++i$) {
      results$.push(i$);
    }
    return results$;
  }
}).call(this);
