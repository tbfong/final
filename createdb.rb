# Set up for the application and database. DO NOT CHANGE. #############################
require "sequel"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB = Sequel.connect(connection_string)                                                #
#######################################################################################
# Database schema - this should reflect your domain model

DB.create_table! :bars do
  primary_key :id
  String :bar_name
  String :description, text: true
  String :location
end
DB.create_table! :reviews do
  primary_key :id
  foreign_key :bar_id
  foreign_key :user_id
  String :comments, text: true
  String :rating
end
DB.create_table! :users do
  primary_key :id
  String :name
  String :email
  String :password
end
# Insert initial (seed) data
bars_table = DB.from(:bars)
bars_table.insert(bar_name: "California Clipper", 
                    description: "Circa-1937 bar with a revamped yet still retro space & a huge list of old-fashioned cocktails.",
                    location: "Chicago, IL")
bars_table.insert(bar_name: "Death & Co.", 
                    description: "Bartenders in bow ties & suspenders recall the speakeasy era at this dark, moody cocktail lounge.",
                    location: "New York, NY")