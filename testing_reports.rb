#!/usr/bin/env ruby
require 'savon'
require 'colorize'
aee_url = 'http://wss.prepa.com/services/BreakdownReport?wsdl'
pueblos = Array.new
hash_pueblo = Hash.new

aee_client = Savon.client(wsdl: aee_url)
breakdownSummary = aee_client.call(:get_breakdowns_summary)
hashtable = breakdownSummary.body

hashtable.each do |key, value|
	cantidad_de_pueblos = value[:return].length
	for cada_pueblo in 1..cantidad_de_pueblos
		cada_pueblo -= 1
		pueblos.push value[:return][cada_pueblo][:r1_town_or_city]
	end
end

pueblos.each do |value|
	breakdownstuff = aee_client.call(:get_breakdowns_by_town_or_city, message: { "townOrCity" => value })
	data = breakdownstuff.body
	if data[:get_breakdowns_by_town_or_city_response][:return].kind_of?(Array)
		cantidad_averias_pueblo = data[:get_breakdowns_by_town_or_city_response][:return].length
		hash_averia = Array.new
		for averias in 1..cantidad_averias_pueblo
			averias -= 1
			hash_averia[averias] = data[:get_breakdowns_by_town_or_city_response][:return][averias][:r2_area] 
		end
		hash_pueblo["#{data[:get_breakdowns_by_town_or_city_response][:return][averias][:r1_town_or_city]}"] = hash_averia
	else
		hash_pueblo["#{data[:get_breakdowns_by_town_or_city_response][:return][:r1_town_or_city]}"] = data[:get_breakdowns_by_town_or_city_response][:return][:r2_area]
	end
end

puts hash_pueblo

