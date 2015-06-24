#!/usr/bin/env ruby
require 'savon'
require 'colorize'
aee_url = 'http://wss.prepa.com/services/BreakdownReport?wsdl'
towns = Array.new

aee_client = Savon.client(wsdl: aee_url)
breakdowns_data = aee_client.call(:get_breakdowns_summary)
breakdowns_summary = breakdowns_data.body

breakdowns_summary.each do |key, value|
	amount_of_towns = value[:return].length
	for cada_pueblo in 0...amount_of_towns
		towns.push value[:return][cada_pueblo][:r1_town_or_city]
	end
end

towns.each do |value|
	breakdowns_per_town = aee_client.call(:get_breakdowns_by_town_or_city, message: { "townOrCity" => value })
	total_breakdowns = breakdowns_per_town.body
	if total_breakdowns[:get_breakdowns_by_town_or_city_response][:return].kind_of?(Array)
		for breakdowns in 0...total_breakdowns[:get_breakdowns_by_town_or_city_response][:return].length
			puts "***************************************"
			puts "Town: " + total_breakdowns[:get_breakdowns_by_town_or_city_response][:return][breakdowns][:r1_town_or_city]
			puts "Area: " + total_breakdowns[:get_breakdowns_by_town_or_city_response][:return][breakdowns][:r2_area]
			puts "Status: " + total_breakdowns[:get_breakdowns_by_town_or_city_response][:return][breakdowns][:r3_status]
			puts "Last Update: " + total_breakdowns[:get_breakdowns_by_town_or_city_response][:return][breakdowns][:r4_last_update]
			puts "***************************************"
		end
	else
		puts "***************************************"
		puts "Town: " + total_breakdowns[:get_breakdowns_by_town_or_city_response][:return][:r1_town_or_city]
		puts "Area: " + total_breakdowns[:get_breakdowns_by_town_or_city_response][:return][:r2_area]
		puts "Status: " + total_breakdowns[:get_breakdowns_by_town_or_city_response][:return][:r3_status]
		puts "Last Update: " + total_breakdowns[:get_breakdowns_by_town_or_city_response][:return][:r4_last_update]
		puts "***************************************"
	end
end
