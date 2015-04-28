require 'mongo'
require 'json'
require 'faker'
require 'active_support/all'
include Mongo

# Connect to DB
@client = MongoClient.new('127.0.0.1', 27017)
@db     = @client['on_time_api_development']
@coll_buses   = @db['locations']
@coll_trams   = @db['trams']
@coll_messages = @db['messages']

# Drop all collections before begining
@coll_buses.drop
@coll_trams.drop
@coll_messages.drop

buses = []
trams = []
messages = []

# Load up bus locations from file to array
File.open("buses.csv", "r") do |f|
  f.each_line do |line|
    line_n = rand(1..130)
    buses.push({ :line => line_n, :trans_type => "bus", :location => { :coordinates => line.chomp.split(",").map(&:to_f), :type => 'Point' } })
  end
end

# Load up tram locations from file to array
File.open("trams.csv", "r") do |f|
  f.each_line do |line|
    line_n = rand(1..15)
    trams.push({ :line => line_n, :trans_type => "tram", :location => { :coordinates => line.chomp.split(",").map(&:to_f), :type => 'Point' } })
  end
end

# Load up messages from file to array
File.open("messages.csv", "r") do |f|
  f.each_line do |line|
    messages.push({ :rating => rand(-10..10), 
                    :message => Faker::Lorem.sentence(3),
                    :user => Faker::Internet.user_name,
                    :location => { :coordinates => line.chomp.split(",").map(&:to_f), :type => 'Point' }
                  })
  end
end

# Concatenate buses and trams and push into DB
buses.concat(trams).each { |loc| @coll_buses.insert(loc) }

# Push messages into DB
messages.each { |message| @coll_messages.insert(message) }

# Create geospatial indexes for buses,trams and messages
@coll_buses.create_index( [['location', '2dsphere' , 'min', '-180', 'max', '180' ]] ) 
@coll_messages.create_index( [['location', '2dsphere' , 'min', '-180', 'max', '180' ]] )
