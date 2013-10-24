#requires router package 
#install using npm install router
#router  = (require 'router')()
http    = require 'http'
fs	    = require 'fs'
url 	= require 'url'
fixture = (name) ->
	fs.readFileSync "#{__dirname}/EventFullTests/Fixtures/#{name}.json"

	
#router.get '/events/search', (req,res) ->
#	res.writeHead(200,{'Content-Type':'application/json'})
#	res.end(fixture 'events')

#router.get '/events/get', (req,res) ->


server = (req, res) ->
	filename = url.parse(req.url).pathname.replace(/^\//,'');
	res.writeHead(200,{'Content-Type':'application/json'})
	res.end(fixture filename)	
		
console.log 'listening to localhost:8080'
http.createServer(server).listen 8080, 'localhost'