# myapp.rb
require 'sinatra'
require 'active_record'

class Bikepark < ActiveRecord::Base
  
end

get '/' do
  ActiveRecord::Base.establish_connection(
                                          :adapter  => "mysql2",
                                          :host     => "localhost",
                                          :username => "root",
                                          :password => "root",
                                          :database => "bikespot"
                                          )

  a = Bikepark.new(:x => 1, :y => 2, :capacity => 3)
  a.save
  body 'hello'
end


