# Set up for the application and database. DO NOT CHANGE. #############################
require "sinatra"                                                                     #
require "sinatra/reloader" if development?                                            #
require "sequel"                                                                      #
require "logger"                                                                      #
require "twilio-ruby"                                                                 #
require "bcrypt"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB ||= Sequel.connect(connection_string)                                              #
DB.loggers << Logger.new($stdout) unless DB.loggers.size > 0                          #
def view(template); erb template.to_sym; end                                          #
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret'           #
before { puts; puts "--------------- NEW REQUEST ---------------"; puts }             #
after { puts; }                                                                       #
#######################################################################################
bars_table = DB.from(:bars)
reviews_table = DB.from(:reviews)

get "/" do
    puts bars_table.all 
    @bars = bars_table.all.to_a
    view "bars"
end

get "/bars/:id" do
    @bar = bars_table.where(id: params[:id]).to_a[0]
    @review = reviews_table.where(bar_id: @bar[:id])
    #@users_table = users_table
    view "bar"
end
get "/bars/:id/reviews/new" do
    @bar = bars_table.where(id: params[:id]).to_a[0]
    view "new_review"
end
get "/bars/:id/reviews/create" do
    puts params
    @bar = bars_table.where(id: params["id"]).to_a[0]
    reviews_table.insert(bar_id: params["id"],
#                       user_id: session["user_id"],
                       comments: params["comments"])
    view "create_review"
end