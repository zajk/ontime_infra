require 'mongo'
require 'json'
require 'faker'
require 'active_support/all'
include Mongo

# Connect to DB
@client = MongoClient.new('127.0.0.1', 27017)
@db     = @client['cityos']
@coll_buses   = @db['buses']
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
    buses.push({ :line => line_n, :transport_type => "bus", :type => "Point", :location => line.chomp.split(",").map(&:to_f) })
  end
end

# Load up tram locations from file to array
File.open("trams.csv", "r") do |f|
  f.each_line do |line|
    line_n = rand(1..15)
    trams.push({ :line => line_n, :transport_type => "tram", :type => "Point", :location => line.chomp.split(",").map(&:to_f) })
  end
end

# Load up messages from file to array
File.open("messages.csv", "r") do |f|
  f.each_line do |line|
    messages.push({ :rating => rand(-10..10), 
                    :message => Faker::Lorem.sentence(3),
                    :user => Faker::Internet.user_name,
                    :location => line.chomp.split(",").map(&:to_f)
                  })
  end
end

# Concatenate buses and trams and push into DB
buses.concat(trams).each { |loc| @coll_buses.insert(loc) }

# Push messages into DB
messages.each { |message| @coll_messages.insert(message) }

# Create geospatial indexes for buses,trams and messages
@coll_buses.create_index( [['location', Mongo::GEO2D , 'min', '-180', 'max', '180' ]] ) 
@coll_trams.create_index( [['location', Mongo::GEO2D , 'min', '-180', 'max', '180' ]] )
@coll_messages.create_index( [['location', Mongo::GEO2D , 'min', '-180', 'max', '180' ]] )
