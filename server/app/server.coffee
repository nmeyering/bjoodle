http = require 'http'
url = require 'url'
querystring = require 'querystring'
check_format = require './check_format'

schedule = {}

module.exports = http.createServer (req, res) ->

	send = (code, msg) ->
		res.writeHead code,
			'Content-Type': 'text/plain'
		res.end msg

	parsedUrl = url.parse req.url, true
	endpoint = parsedUrl.pathname
	params = parsedUrl.query

	if endpoint != '/api'
		return send 404

	headers = {}

	requestData = ''

	switch req.method
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
					# TODO should we use an array instead?
					schedule[requestData.name] = requestData.times
					send 200, 'thanks'
				else
					send 400, 'invalid schedule format'
		else
			schedule = {}