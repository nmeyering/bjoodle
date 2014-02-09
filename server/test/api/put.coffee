env = require 'setup_test_env'


describe 'PUT request', ->
	describe 'with no data', ->
		it 'should be rejected', (done) ->
			env.request
				.put(env.endpoint)
				.send('')
				.expect(400, done)

	example = ->
		'name': 'test'
		'times': [
			null,
			'12:30',
			null,
			null,
			'10:00',
			null,
			null
		]
	describe 'with a valid request object', ->
		it 'should be a accepted', (done) ->
			data = JSON.stringify example()
			env.request
				.put(env.endpoint)
				.set('content-type': 'application/json')
				.set('content-length': data.length)
				.send(data)
				.expect(200, done)
