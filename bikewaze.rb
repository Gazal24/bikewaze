# myapp.rb
require 'sinatra'
require 'active_record'

class Bikepark < ActiveRecord::Base
  self.table_name = "bikeparks"
end

class Bikeparkstatus < ActiveRecord::Base
  self.table_name = "bikeparkstatus"
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

get '/newbikepark' do
  con
  @x = params[:x]
  @y = params[:y]
  @capacity = params[:capacity]
  a = Bikepark.new(:x => @x, :y => @y, :capacity => @capacity)
  a.save
  body "saved!"
end

get '/checkin' do
  con
  @user = params[:user]
  @x = params[:x]
  @y = params[:y]
  @available = params[:available]
  @bike_park_id = 1 #Bikepark.find() // Algo Load (@x, @y)
  a = Bikeparkstatus.new(:user_id => @user, :bike_park_id => @bike_park_id, :available => @available, :time => Time.now)
  a.save
  body "Checked IN!!"
end

get '/availability' do
  con
  @x = params[:x]
  @y = params[:y]
  # Write a find query
  body "Return Number or Y/N"
end

def con
  ActiveRecord::Base.establish_connection(
  :adapter  => "mysql2",
  :host     => "localhost",
  :username => "root",
  :password => "root",
  :database => "bikespot")
end
