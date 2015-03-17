#!/usr/bin/env ruby
require 'savon'

aee_url = 'http://wss.prepa.com/services/BreakdownReport?wsdl'
aee_client = Savon.client(wsdl: aee_url)
breakdownSummary = aee_client.call(:get_breakdowns_summary)

hashtable = breakdownSummary.body

hashtable.each do |key, value|
	puts "Pueblos disponibles: "
	for cada_pueblo in 0...value[:return].length
		puts value[:return][cada_pueblo][:r1_town_or_city] + " " + value[:return][cada_pueblo][:r2_total_breakdowns]
	end
end

print "Pueblo: "
pueblito = STDIN.gets.chomp()
pueblito.upcase

breakdownstuff = aee_client.call(:get_breakdowns_by_town_or_city, message: { "townOrCity" => pueblito })

hash_table = breakdownstuff.body
hash_table.each do |key, value|
	# Checks if it is an array of hashes containing all the averias specified to that town
	# or a single hash with the specific breakdown for that pueblo
	if value[:return].kind_of?(Array)
		for averias in 0...value[:return].length
			puts "***************************************"
			puts "Pueblo: " + value[:return][averias][:r1_town_or_city]
			puts "Area: " + value[:return][averias][:r2_area]
			puts "Status: " + value[:return][averias][:r3_status]
			puts "Last Update: " + value[:return][averias][:r4_last_update]
			puts "***************************************"
		end
	else
		puts "***************************************"
		puts "Pueblo: " + value[:return][:r1_town_or_city]
		puts "Area: " + value[:return][:r2_area]
		puts "Status: " + value[:return][:r3_status]
		puts "Last Update: " + value[:return][:r4_last_update]
		puts "***************************************"
	end
end