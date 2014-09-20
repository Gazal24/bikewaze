# myapp.rb
require 'sinatra'
require 'active_record'

class Bikepark < ActiveRecord::Base
  self.table_name = "bikeparks"
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

get '/checkin' do
  ActiveRecord::Base.establish_connection(
                                          :adapter  => "mysql2",
                                          :host     => "localhost",
                                          :username => "root",
                                          :password => "root",
                                          :database => "bikespot"
                                          )

  @x = params[:x]
  @y = params[:y]
  @available = params[:available]
  a = Bikepark.new(:x => @x, :y => @y, :capacity => @available)
  a.save
  # if x.nil?
  #   body "no"
  # else
  #   body  "moo"
  # end
end

get '/availability' do
  con
  x = Bikepark.last
  body x.id.to_s
end

def con
  ActiveRecord::Base.establish_connection(
                                          :adapter  => "mysql2",
                                          :host     => "localhost",
                                          :username => "root",
                                          :password => "root",
                                          :database => "bikespot"
                                          )
end



