env = require 'setup_test_env'


describe 'GET request with no parameters', ->
	it 'should return some JSON', (done) ->
		env.request
			.get(env.endpoint)
			.expect('content-type', /json/)
			.expect(200, done)
	it 'should be a valid schedule object', (done) ->
		env.request
			.get(env.endpoint)
			.expect('content-type', /json/)
			.expect(200)
			.end (err, res) ->
				return done err if err?
				unless env.check_format.schedule res.body
					return done new Error 'malformed response!'
				done()


