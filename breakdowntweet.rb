#!/usr/bin/env ruby
require 'savon'

aee_url = 'http://wss.prepa.com/services/BreakdownReport?wsdl'

aee_client = Savon.client(wsdl: aee_url)

