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
		for breakdowns in 0...value[:return].length
			 client.update("OOPS! @AEEONLINE tienes una averia en: " + value[:return][breakdowns][:r1_town_or_city] + " " + value[:return][breakdowns][:r2_area])
		end
	else
		client.update("OOPS! @AEEONLINE tienes una averia en: " + value[:return][:r1_town_or_city] + ", " + value[:return][:r2_area])
	end
end
