#!/usr/bin/env ruby
require 'savon'

aee_url = 'http://wss.prepa.com/services/BreakdownReport?wsdl'
aee_client = Savon.client(wsdl: aee_url)
breakdowns_data = aee_client.call(:get_breakdowns_summary)

breakdowns_summary = breakdowns_data.body

breakdowns_summary.each do |key, value|
	puts "Available Towns: "
	amount_of_towns = value[:return].length
	for town in 0...amount_of_towns
		puts value[:return][town][:r1_town_or_city] + " " + value[:return][town][:r2_total_breakdowns]
	end
end

print "Town: "
input_town = STDIN.gets.chomp()

breakdowns_per_town = aee_client.call(:get_breakdowns_by_town_or_city, message: { "townOrCity" => input_town.upcase })

hash_breakdonws_per_town = breakdowns_per_town.body
hash_breakdonws_per_town.each do |key, value|
	# Checks if it is an array of hashes containing all the averias specified to that town
	# or a single hash with the specific breakdown for that pueblo
	if value[:return].kind_of?(Array)
		for averias in 0...value[:return].length
			puts "***************************************"
			puts "Town: " + value[:return][averias][:r1_town_or_city]
			puts "Area: " + value[:return][averias][:r2_area]
			puts "Status: " + value[:return][averias][:r3_status]
			puts "Last Update: " + value[:return][averias][:r4_last_update]
			puts "***************************************"
		end
	else
		puts "***************************************"
		puts "Town: " + value[:return][:r1_town_or_city]
		puts "Area: " + value[:return][:r2_area]
		puts "Status: " + value[:return][:r3_status]
		puts "Last Update: " + value[:return][:r4_last_update]
		puts "***************************************"
	end
end