http = require 'http'
url = require 'url'
querystring = require 'querystring'
check_format = require './check_format'
config = require './config'

schedule = {}

module.exports = http.createServer (req, res) ->
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

	if endpoint != '/api'
		return send 404

	requestData = ''

	headers = {}
	headers['Access-Control-Allow-Origin'] = '*'
	headers['Access-Control-Allow-Methods'] = 'POST,GET,PUT,OPTIONS'
	headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Accept";
	headers["Access-Control-Allow-Credentials"] = false;
	headers["Access-Control-Max-Age"] = '86400';

	switch req.method
		when 'OPTIONS'
			res.writeHead 200,
				headers
			res.end body
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
			schedule = {}
			send 204
		else
			send 501, 'method not supported'
