TIMESTAMP = ///
	^
	[0-2][0-9]		# hour digits
	:				# colon
	(00|30)			# minute digits, TODO: allow other values?
	$
///

check_format = (schedule) ->
	unless typeof schedule == 'object'
		return false

	unless 'name' of schedule
		return false
	unless typeof schedule.name == 'string'
		return false

	unless 'times' of schedule
		return false
	unless schedule.times.length == 7
		return false
	for time in schedule.times
		if time == null
			continue
		unless typeof time == 'string'
			return false
		unless TIMESTAMP.test time
			return false
		[hours, minutes] = time.split ':'
		[hours, minutes] = [Number hours, Number minutes]
		unless hours >= 0 and hours <= 23
			return false
		unless minutes >=0 and minutes <= 59
			return false

	return true

module.exports = check_format
