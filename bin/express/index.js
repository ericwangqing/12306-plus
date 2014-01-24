(function(){
  var express, app;
  express = require('express');
  app = express();
  app.get('/', function(req, res){
    var body;
    body = 'hello express';
    res.setHeader('Content-Type', 'text/plain');
    res.setHeader('Content-Length', Buffer.byteLength(body));
    res.end(body);
  });
  app.listen(3010);
}).call(this);
