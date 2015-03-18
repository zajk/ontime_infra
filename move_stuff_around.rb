require 'mongo'
require 'csv'
require 'json'
require 'faker'
require 'active_support/all'
include Mongo

@client = MongoClient.new('localhost', 27017)
@db     = @client['cityos']
@coll_buses   = @db['buses']
@coll_trams   = @db['trams']


Thread.new do
  loop do
    exit if gets.chomp == 'q'
  end
end

a = 0
loop do
  a += 1
  puts a

  @coll_buses.find.each_slice(10) do |slice|
    slice.each do |bus|
      bus_long = bus['location'][0] + 0.000120 
      bus_lat = bus['location'][1] + 0.000120

      @coll_buses.update({"_id" => bus['_id']}, {"$set" => {"location" => [ bus_long, bus_lat] }})
    end
  end

  @coll_trams.find.each_slice(10) do |slice|
    slice.each do |tram|
      tram_long = tram['location'][0] + 0.000120 
      tram_lat = tram['location'][1] + 0.000120 

      @coll_trams.update({"_id" => tram['_id']}, {"$set" => {"location" => [ tram_long, tram_lat] }})
    end
  end

  sleep 3
end

