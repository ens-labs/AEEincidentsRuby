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
			client.update("OOPS! @AEEONLINE tienes una averia en: " + total_breakdowns[:get_breakdowns_by_town_or_city_response][:return][breakdowns][:r1_town_or_city] + " " + total_breakdowns[:get_breakdowns_by_town_or_city_response][:return][breakdowns][:r2_area])
		end
	else
		client.update("OOPS! @AEEONLINE tienes una averia en: " + total_breakdowns[:get_breakdowns_by_town_or_city_response][:return][:r1_town_or_city] + " " + total_breakdowns[:get_breakdowns_by_town_or_city_response][:return][:r2_area])
	end
end
