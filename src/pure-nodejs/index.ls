require! 'http'

http.create-server (req, res)!->
  res.write-head 200, 'Content-Type': 'text/plain'
  res.write 'hello world'
  res.end!
.listen 4010