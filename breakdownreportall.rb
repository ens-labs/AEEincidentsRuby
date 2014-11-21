#!/usr/bin/env ruby
require 'savon'

aee_url = 'http://wss.prepa.com/services/BreakdownReport?wsdl'

aee_client = Savon.client(wsdl: aee_url)

breakdownSummary = aee_client.call(:get_breakdowns_summary)

hashtable = breakdownSummary.body

pueblos = Array.new

hashtable.each do |key, value|
	cantidad_de_pueblos = value[:return].length
	for cada_pueblo in 1..cantidad_de_pueblos
		cada_pueblo -= 1
		pueblos.push value[:return][cada_pueblo][:r1_town_or_city]
	end
	for pueblo in 1..pueblos.length
		pueblo -= 1
		breakdownstuff = aee_client.call(:get_breakdowns_by_town_or_city, message: { "townOrCity" => pueblos[pueblo] })
		hash_table = breakdownstuff.body
		hash_table.each do |key, value|
			cantidad_averias_pueblo = value[:return].length
			# Checks if its an array of hashes or a hash
			if value[:return].kind_of?(Array)
				for averias in 1..cantidad_averias_pueblo
					averias -= 1
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
	end
end