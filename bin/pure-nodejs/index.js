(function(){
  var http;
  http = require('http');
  http.createServer(function(req, res){
    res.writeHead(200, {
      'Content-Type': 'text/plain'
    });
    res.write('hello world');
    res.end();
  }).listen(4010);
}).call(this);
