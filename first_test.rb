require 'rubygems'
require 'oauth'
require 'yaml'
require 'json'

# Import secrets and authenticate
config = YAML.load_file("config.yaml")
consumer_key = OAuth::Consumer.new(
    config["twitter"]["consumer_key"],
    config["twitter"]["consumer_secret"])
access_token = OAuth::Token.new(
    config["twitter"]["access_token"],
    config["twitter"]["access_token_secret"])

	
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

def parse_user_response(response)
  user = nil

  # Check for a successful request
  if response.code == '200'
    # Parse the response body, which is in JSON format.
    user = JSON.parse(response.body)

    # Print some user data!
    puts "Screen Name: #{user["screen_name"]}"
	puts "Language: #{user["lang"]}"
	puts "Location: #{user["location"]}"
	puts "Description: #{user["description"]}"
  else
    # There was an error issuing the request.
    puts "Expected a response of 200 but got #{response.code} instead"
  end

  user
end

user = parse_user_response(response)