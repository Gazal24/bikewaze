var app = require('http').createServer(handler),
    fs = require('fs');
 
function handler (req, res) { 
    console.log(req.url);
  if(req.url            === "/"){
    fs.readFile(__dirname + '/public/index.html',
        function (err, data) {
          if (err) {
            res.writeHead(500);
            return res.end('Error loading index.html');
          }
          res.writeHead(200);
          res.end(data);
        });
  }
  else{
    fs.readFile(__dirname + "/public"+req.url, function (err, data) {
      if (err) {
        console.log("500 ERROR HAPPENING! - " + req.url);
        res.writeHead(500);
        return res.end('Error loading ' +"/public"+req.url);
      }
      res.writeHead(200);
      res.end(data);
    });
  }
}
app.listen(8080);
