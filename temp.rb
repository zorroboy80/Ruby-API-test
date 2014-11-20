require 'rubygems'
require 'oauth'
require 'yaml'

# Import codes etc.
config = YAML.load_file("config.yaml")
puts config["twitter"]["consumer_key1"]
puts config["twitter"]["consumer_key2"]
puts config["twitter"]["access_token1"]
puts config["twitter"]["access_token2"]

puts config["twitter"]["access_token2"].class