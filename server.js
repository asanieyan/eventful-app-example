// Generated by CoffeeScript 1.6.3
(function() {
  var fixture, fs, http, server, url;

  http = require('http');

  fs = require('fs');

  url = require('url');

  fixture = function(name) {
    return fs.readFileSync("" + __dirname + "/EventFullTests/Fixtures/" + name + ".json");
  };

  server = function(req, res) {
    var filename;
    filename = url.parse(req.url).pathname.replace(/^\//, '');
    res.writeHead(200, {
      'Content-Type': 'application/json'
    });
    return res.end(fixture(filename));
  };

  console.log('listening to localhost:8080');

  http.createServer(server).listen(8080, 'localhost');

}).call(this);
