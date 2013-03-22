class Time
	def relative_time(from_time=Time.now)
		from_time = from_time.to_time if from_time.respond_to?(:to_time)
		distance_in_minutes = (((self - from_time).abs)/60).round

		case distance_in_minutes
			when 0..1
			return (distance_in_minutes==0) ? 'just seconds ago' : '1 min ago'
			when 2..45        then "#{distance_in_minutes} mins ago"
			when 46..90       then '1 hr ago'
			when 90..1440     then "#{(distance_in_minutes.to_f / 60.0).round} hrs ago"
			when 1441..2880   then 'Yesterday'
			when 2881..8640   then "#{(distance_in_minutes / 1440).round} days ago"
			when 8641..10080  then '1 week ago'
		else
			strftime year == from_time.year ? '%b %d' : '%b %d, %Y'
		end
	end
end


