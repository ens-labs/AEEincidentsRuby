require 'savon'
aee_url = 'http://wss.prepa.com/services/BreakdownReport?wsdl'
aee_client = Savon.client(wsdl: aee_url)

towns_call = aee_client.call(:get_breakdowns_summary)
towns = towns_call.body[:get_breakdowns_summary_response][:return]

for town in towns
	breakdowns_call = aee_client.call(:get_breakdowns_by_town_or_city, message: { "townOrCity" => town[:r1_town_or_city] })
	breakdowns = breakdowns_call.body

	case breakdowns[:get_breakdowns_by_town_or_city_response][:return].kind_of?(Array)
	 when true
	 	for breakdown in 0...breakdowns[:get_breakdowns_by_town_or_city_response][:return].length
			puts "***************************************"
			puts "Pueblo: " + breakdowns[:get_breakdowns_by_town_or_city_response][:return][breakdown][:r1_town_or_city]
			puts "Area: " + breakdowns[:get_breakdowns_by_town_or_city_response][:return][breakdown][:r2_area]
			puts "Status: " + breakdowns[:get_breakdowns_by_town_or_city_response][:return][breakdown][:r3_status]
			puts "Last Update: " + breakdowns[:get_breakdowns_by_town_or_city_response][:return][breakdown][:r4_last_update]
			puts "***************************************"
		end
	 else
	 	puts "***************************************"
		puts "Pueblo: " + breakdowns[:get_breakdowns_by_town_or_city_response][:return][:r1_town_or_city]
		puts "Area: " + breakdowns[:get_breakdowns_by_town_or_city_response][:return][:r2_area]
		puts "Status: " + breakdowns[:get_breakdowns_by_town_or_city_response][:return][:r3_status]
		puts "Last Update: " + breakdowns[:get_breakdowns_by_town_or_city_response][:return][:r4_last_update]
		puts "***************************************"
	end 
end