require 'rubygems'
require 'oauth'
require 'yaml'

# Import secrets and authenticate
config = YAML.load_file("config.yaml")
consumer_key = OAuth::Consumer.new(
    config["twitter"]["consumer_key1"],
    config["twitter"]["consumer_key2"])
access_token = OAuth::Token.new(
    config["twitter"]["access_token1"],
    config["twitter"]["access_token2"])

	
# All requests will be sent to this server.
baseurl = "https://api.twitter.com"

# The verify credentials endpoint returns a 200 status if
# the request is signed correctly.
address = URI("#{baseurl}/1.1/account/verify_credentials.json")

# Set up Net::HTTP to use SSL, which is required by Twitter.
http = Net::HTTP.new address.host, address.port
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

# Build the request and authorize it with OAuth.
request = Net::HTTP::Get.new address.request_uri
request.oauth! http, consumer_key, access_token

# Issue the request and return the response.
http.start
response = http.request request
puts "The response status was #{response.code}"