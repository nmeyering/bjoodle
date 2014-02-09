TIMESTAMP = ///
	^
	(0?|[1-2])[0-9]	# hour digits
	:
	(00|30)			# minute digits, TODO: allow other values?
	$
///

module.exports =
schedule: (schedule) ->
	unless typeof schedule == 'object'
		return false
	for name of schedule
		# i.e. it's a valid times structure
		unless @times schedule[name]
			return false
	return true

times: (times) ->
	unless times.length == 7
		return false
	for time in times
		if time == null
			continue
		unless typeof time == 'string'
			return false
		unless TIMESTAMP.test time
			return false
		[hours, minutes] = time.split ':'
		[hours, minutes] = [(Number hours), (Number minutes)]
		unless hours >= 0 and hours <= 23
			return false
		unless minutes >=0 and minutes <= 59
			return false
	return true

request: (request) ->
	unless typeof request == 'object'
		return false

	unless 'name' of request
		return false
	unless typeof request.name == 'string'
		return false

	unless 'times' of request
		return false

	unless check_times request.times
		return false

	return true
