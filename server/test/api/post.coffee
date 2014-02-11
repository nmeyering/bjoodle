env = require 'setup_test_env'


describe 'POST request', ->
	describe 'with no data', ->
		it 'should be rejected', (done) ->
			env.request
				.post(env.endpoint)
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
				.post(env.endpoint)
				.set('content-type': 'application/json')
				.set('content-length': data.length)
				.send(data)
				.expect(201, done)
	describe 'with missing times', ->
		it 'should be a rejected', (done) ->
			data = example()
			delete data['times']
			data = JSON.stringify data
			env.request
				.post(env.endpoint)
				.set('content-type': 'application/json')
				.set('content-length': data.length)
				.send(data)
				.expect(400, done)
	describe 'with missing name', ->
		it 'should be rejected', (done) ->
			data = example()
			delete data['name']
			data = JSON.stringify data
			env.request
				.post(env.endpoint)
				.set('content-type': 'application/json')
				.set('content-length': data.length)
				.send(data)
				.expect(400, done)
	describe 'with extra properties', ->
		# TODO should it?
		it 'should be accepted', (done) ->
			data = example()
			data['xxx'] = 42
			data = JSON.stringify data
			env.request
				.post(env.endpoint)
				.set('content-type': 'application/json')
				.set('content-length': data.length)
				.send(data)
				.expect(201, done)
	describe 'with short times list', ->
		it 'should be rejected', (done) ->
			data = example()
			data['times'].length = 5
			data = JSON.stringify data
			env.request
				.post(env.endpoint)
				.set('content-type': 'application/json')
				.set('content-length': data.length)
				.send(data)
				.expect(400, done)
	describe 'with long times list', ->
		it 'should be rejected', (done) ->
			data = example()
			data['times'] = ('23:30' for i in [1..10])
			data = JSON.stringify data
			env.request
				.post(env.endpoint)
				.set('content-type': 'application/json')
				.set('content-length': data.length)
				.send(data)
				.expect(400, done)
	describe 'with a malformed time item', ->
		it 'should be rejected', (done) ->
			data = example()
			data['times'][2] = '59:23'
			data = JSON.stringify data
			env.request
				.post(env.endpoint)
				.set('content-type': 'application/json')
				.set('content-length': data.length)
				.send(data)
				.expect(400, done)
