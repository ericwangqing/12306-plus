(function(){
  var express, http, cluster, numCpus, i$, ref$, len$, i, app;
  express = require('express');
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
    app = express();
    app.get('/', function(req, res){
      var body;
      body = 'hello express';
      res.setHeader('Content-Type', 'text/plain');
      res.setHeader('Content-Length', Buffer.byteLength(body));
      res.end(body);
    });
    app.listen(3011);
  }
  function fn$(){
    var i$, to$, results$ = [];
    for (i$ = 1, to$ = numCpus; i$ <= to$; ++i$) {
      results$.push(i$);
    }
    return results$;
  }
}).call(this);
