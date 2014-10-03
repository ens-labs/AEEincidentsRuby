#!/usr/bin/env ruby
require 'savon'

#This was used for testing purposes
aee_url = 'http://wss.prepa.com/services/BreakdownReport?wsdl'

aee_client = Savon.client(wsdl: aee_url)

breakdownstuff = aee_client.call(:get_breakdowns_by_town_or_city, message: { "townOrCity" => "ADJUNTAS" })

hash_table = breakdownstuff.body
hash_table.each do |key, value|
	cantidad_averias_pueblo = value[:return].length
	puts cantidad_averias_pueblo
	puts value[:return]
	for averias in 1..cantidad_averias_pueblo
		averias -= 1
		puts value[:return][averias]
	end
end