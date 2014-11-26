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
pueblos = Array.new

aee_client = Savon.client(wsdl: aee_url)
breakdownSummary = aee_client.call(:get_breakdowns_summary)
hashtable = breakdownSummary.body

hashtable.each do |key, value|
	cantidad_de_pueblos = value[:return].length
	for cada_pueblo in 1..cantidad_de_pueblos
		cada_pueblo -= 1
		pueblos.push value[:return][cada_pueblo][:r1_town_or_city]
	end
end

pueblos.each do |value|
	breakdownstuff = aee_client.call(:get_breakdowns_by_town_or_city, message: { "townOrCity" => value })
	data = breakdownstuff.body
	if data[:get_breakdowns_by_town_or_city_response][:return].kind_of?(Array)
		cantidad_averias_pueblo = data[:get_breakdowns_by_town_or_city_response][:return].length
		for averias in 1..cantidad_averias_pueblo
			averias -= 1
			client.update("OOPS! @AEEONLINE tienes una averia en: " + data[:get_breakdowns_by_town_or_city_response][:return][averias][:r1_town_or_city] + " " + data[:get_breakdowns_by_town_or_city_response][:return][averias][:r2_area])
		end
	else
		client.update("OOPS! @AEEONLINE tienes una averia en: " + data[:get_breakdowns_by_town_or_city_response][:return][:r1_town_or_city] + " " + data[:get_breakdowns_by_town_or_city_response][:return][:r2_area])
	end
end