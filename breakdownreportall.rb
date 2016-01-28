#!/usr/bin/env ruby
require 'savon'
aee_url = 'http://wss.prepa.com/services/BreakdownReport?wsdl'
all_towns = Array.new

aee_client = Savon.client(wsdl: aee_url)
breakdowns_data = aee_client.call(:get_breakdowns_summary)
breakdowns_summary = breakdowns_data.body

breakdowns_summary.each do |key, value|
	towns = value[:return].length
	for town in 0...towns
		all_towns.push value[:return][town][:r1_town_or_city]
	end
end

all_towns.each do |value|
	breakdown_town = aee_client.call(:get_breakdowns_by_town_or_city, message: { "townOrCity" => value })
	breakdowns = breakdown_town.body
	if breakdowns[:get_breakdowns_by_town_or_city_response][:return].kind_of?(Array)
		for breakdown in 0...breakdowns[:get_breakdowns_by_town_or_city_response][:return].length
			puts "***************************************"
			puts "Town: " + breakdowns[:get_breakdowns_by_town_or_city_response][:return][breakdown][:r1_town_or_city]
			puts "Area: " + breakdowns[:get_breakdowns_by_town_or_city_response][:return][breakdown][:r2_area]
			puts "Status: " + breakdowns[:get_breakdowns_by_town_or_city_response][:return][breakdown][:r3_status]
			puts "Last Update: " + breakdowns[:get_breakdowns_by_town_or_city_response][:return][breakdown][:r4_last_update]
			puts "***************************************"
		end
	else
		puts "***************************************"
		puts "Town: " + breakdowns[:get_breakdowns_by_town_or_city_response][:return][:r1_town_or_city]
		puts "Area: " + breakdowns[:get_breakdowns_by_town_or_city_response][:return][:r2_area]
		puts "Status: " + breakdowns[:get_breakdowns_by_town_or_city_response][:return][:r3_status]
		puts "Last Update: " + breakdowns[:get_breakdowns_by_town_or_city_response][:return][:r4_last_update]
		puts "***************************************"
	end
end
