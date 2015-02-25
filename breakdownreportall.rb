#!/usr/bin/env ruby
require 'savon'
require 'colorize'
aee_url = 'http://wss.prepa.com/services/BreakdownReport?wsdl'
pueblos = Array.new

aee_client = Savon.client(wsdl: aee_url)
breakdownSummary = aee_client.call(:get_breakdowns_summary)
hashtable = breakdownSummary.body

hashtable.each do |key, value|
	for cada_pueblo in 0...value[:return].length
		pueblos.push value[:return][cada_pueblo][:r1_town_or_city]
	end
end

pueblos.each do |value|
	breakdownstuff = aee_client.call(:get_breakdowns_by_town_or_city, message: { "townOrCity" => value })
	data = breakdownstuff.body
	if data[:get_breakdowns_by_town_or_city_response][:return].kind_of?(Array)
		for averias in 0...data[:get_breakdowns_by_town_or_city_response][:return].length
			puts "***************************************"
			puts "Pueblo: " + data[:get_breakdowns_by_town_or_city_response][:return][averias][:r1_town_or_city]
			puts "Area: " + data[:get_breakdowns_by_town_or_city_response][:return][averias][:r2_area]
			puts "Status: " + data[:get_breakdowns_by_town_or_city_response][:return][averias][:r3_status]
			puts "Last Update: " + data[:get_breakdowns_by_town_or_city_response][:return][averias][:r4_last_update]
			puts "***************************************"
		end
	else
		puts "***************************************"
		puts "Pueblo: " + data[:get_breakdowns_by_town_or_city_response][:return][:r1_town_or_city]
		puts "Area: " + data[:get_breakdowns_by_town_or_city_response][:return][:r2_area]
		puts "Status: " + data[:get_breakdowns_by_town_or_city_response][:return][:r3_status]
		puts "Last Update: " + data[:get_breakdowns_by_town_or_city_response][:return][:r4_last_update]
		puts "***************************************"
	end
end