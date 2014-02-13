http = require 'http'
url = require 'url'
querystring = require 'querystring'
check_format = require './check_format'
config = require './config'
fs = require 'fs'
mime = require 'mime'

schedule = {}

# cobbled together piece of webserver
serveStatic = (file, req, res) ->
	unless config.serveHTML
		res.end
		return
	unless req.method == 'GET'
		res.end
		return

	if file == '' or file == '/'
		file = '/index.html'
	file = '../client' + file

	unless fs.existsSync file
		res.writeHead 404,
			'Content-Type': 'text/plain'
		res.end 'not found'
		return

	res.writeHead 200,
		'Content-Type': mime.lookup file
		'Content-Length': (fs.statSync file).size

	reader = fs.createReadStream file
	reader.pipe res

module.exports = http.createServer (req, res) ->
	req.on 'error', (err) -> console.log err
	if config.debug
		console.log "Received #{req.method} request for #{req.url}"
		console.log req.headers

	send = (code, msg) ->
		res.writeHead code,
			'Content-Type': 'text/plain',
			'Access-Control-Allow-Origin' : '*'
		res.end msg

	parsedUrl = url.parse req.url, true
	endpoint = parsedUrl.pathname
	params = parsedUrl.query

	unless endpoint in ['/api', '/api/']
		return serveStatic endpoint, req, res

	requestData = ''

	headers =
		'Access-Control-Allow-Origin': '*'
		'Access-Control-Allow-Methods': 'POST,GET,PUT,OPTIONS'
		'Access-Control-Allow-Headers':
			req.headers?['Access-Control-Request-Headers'] or ''
		'Access-Control-Allow-Credentials': false
		'Access-Control-Max-Age': '86400'

	switch req.method
		when 'OPTIONS'
			res.writeHead 200,
				headers
			res.end
		when 'GET'
			body = JSON.stringify schedule

			headers['Content-Type'] = 'application/json'
			headers['Content-Length'] = body.length
			res.writeHead 200,
				headers
			res.end body
		when 'POST', 'PUT'
			req.on 'data', (data) ->
				requestData += data
			req.on 'end', ->
				try
					requestData = JSON.parse requestData
				catch e
					return send 400, 'unable to parse request as JSON'
				if check_format.request requestData
					schedule[requestData.name] = requestData.times
					send 201, 'thanks'
				else
					send 400, 'invalid schedule format'
		when 'DELETE'
			bjboy = params['name']
			delete schedule[bjboy] if bjboy?
			send 200
		else
			send 501, 'method not supported'
