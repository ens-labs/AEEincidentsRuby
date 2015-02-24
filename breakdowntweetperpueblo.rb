#!/usr/bin/env ruby
require 'rubygems'
require 'open-uri'
require 'savon'
require 'twitter'

#Twitter stuff
client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "SECRET THINGS"
  config.consumer_secret     = "SECRET THINGS"
  config.access_token        = "SECRET THINGS"
  config.access_token_secret = "SECRET THINGS"
end

aee_url = 'http://wss.prepa.com/services/BreakdownReport?wsdl'

aee_client = Savon.client(wsdl: aee_url)

breakdownSummary = aee_client.call(:get_breakdowns_summary)

hashtable = breakdownSummary.body

hashtable.each do |key, value|
	cantidad_de_pueblos = value[:return].length
	puts "Pueblos disponibles: "
	for cada_pueblo in 0...cantidad_de_pueblos
		puts value[:return][cada_pueblo][:r1_town_or_city] + " " + value[:return][cada_pueblo][:r2_total_breakdowns]
	end
end


# WORK IN PROGRESS - DONE
print "Pueblo: "
pueblito = STDIN.gets.chomp()

breakdownstuff = aee_client.call(:get_breakdowns_by_town_or_city, message: { "townOrCity" => pueblito.upcase })

hash_table = breakdownstuff.body
hash_table.each do |key, value|
	cantidad_averias_pueblo = value[:return].length
	# Checks if its an array of hashes or a single hash
	if value[:return].kind_of?(Array)
		for averias in 0...cantidad_averias_pueblo
			  client.update("OOPS! @AEEONLINE tienes una averia en: " + value[:return][averias][:r1_town_or_city] + " " + value[:return][averias][:r2_area])
		end
	else
		client.update("OOPS! @AEEONLINE tienes una averia en: " + value[:return][:r1_town_or_city] + ", " + value[:return][:r2_area])
	end
end
