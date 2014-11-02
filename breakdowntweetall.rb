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

pueblos = Array.new

hashtable.each do |key, value|
	cantidad_de_pueblos = value[:return].length
	for cada_pueblo in 1..cantidad_de_pueblos
		cada_pueblo -= 1
		pueblos.push value[:return][cada_pueblo][:r1_town_or_city]
	end
	for Pueblo in 1..pueblos.length
		Pueblo -= 1
		breakdownstuff = aee_client.call(:get_breakdowns_by_town_or_city, message: { "townOrCity" => pueblos[Pueblo] })
		hash_table = breakdownstuff.body
		hash_table.each do |key, value|
			cantidad_averias_pueblo = value[:return].length
			# Checks if its an array of hashes or a hash
			if value[:return].kind_of?(Array)
				for averias in 1..cantidad_averias_pueblo
					averias -= 1
					client.update("OOPS! @AEEONLINE tienes una averia en: " + value[:return][averias][:r1_town_or_city] + " " + value[:return][averias][:r2_area])
				end
			else
				client.update("OOPS! @AEEONLINE tienes una averia en: " + value[:return][:r1_town_or_city] + ", " + value[:return][:r2_area])
			end
		end
	end
end