# myapp.rb
require 'sinatra'
require 'active_record'
require 'json'

class Bikepark < ActiveRecord::Base
  self.table_name = "bikeparks"
end

class Bikeparkstatus < ActiveRecord::Base
  self.table_name = "bikeparkstatus"
end

get '/bike' do
  File.read(File.join('public', 'bike.html'))
end

get '/' do
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
  @nearest_bike =  get_nearest_bike_park(@x, @y)
  if !@nearest_bike.blank?
    a = Bikeparkstatus.new(:user_id => @user, :bike_park_id => @nearest_bike.id, :available => @available, :time => Time.now, :type_id => 1)
    a.save
  else
    body "No nearby locaiton found."
  end
end


get '/checkout' do
  con
  @user = params[:user]
  @x = params[:x]
  @y = params[:y]
  @available = -1
  @bike_park_id = 1 #Bikepark.find() // Algo Load (@x, @y)
  @nearest_bike =  get_nearest_bike_park(@x, @y)
  if !@nearest_bike.blank?
    a = Bikeparkstatus.new(:user_id => @user, :bike_park_id => @nearest_bike.id, :available => @available, :time => Time.now, :type_id => 0)
    a.save
  else
    body "No nearby locaiton found."
  end
end


get '/availability' do
  con
  @x = params[:x]
  @y = params[:y]
  # Write a find query
  @nearest_5_bp =  get_5_nearby_bike_park(@x, @y)
  @nearest_5_hash = {} 
  counter = 1
  available = 2
  @nearest_5_bp.each {|k,v|
    bpstatus = Bikeparkstatus.where(:bike_park_id => k.id).order(:time).reverse_order
    puts bpstatus.empty?
    if(bpstatus.empty? or bpstatus.first.available == -1)
      available = k.capacity
    else 
      available = bpstatus.first.available
    end
    @nearest_5_hash[counter] = {'x' => k.x, 'y' => k.y, 'ava' => available}
    counter = counter + 1
  }
  @json = JSON.generate(@nearest_5_hash)
  body @json
end

def get_nearest_bike_park x,y
  nearby_bp = {}
  min_dist = 10000000
  nearest_bp = nil
  Bikepark.all.each{|bp|
    next if bp.x.blank? or bp.y.blank?
    d = distance([bp.x, bp.y], [x.to_f,y.to_f])
    next if d == -1
    nearby_bp[bp] = d
    if(d < min_dist)
      min_dist = d
      nearest_bp = bp
    end
  }
  return nearest_bp
end


def get_5_nearby_bike_park x,y
  nearby_bp = {}
  Bikepark.all.each {|bp|
    next if bp.x.blank? or bp.y.blank?
    d = distance([bp.x, bp.y], [x.to_f,y.to_f])
    next if d == -1
    nearby_bp[bp] = d
  }
  nearest_5_bp = nearby_bp.sort_by{|k,v| -v}.first(5)
  return nearest_5_bp
end


def con
  ActiveRecord::Base.establish_connection(
  :adapter  => "mysql2",
  :host     => "localhost",
  :username => "root",
  :password => "root",
  :database => "bikespot")
end


def distance a, b
  rad_per_deg = Math::PI/180  # PI / 180
  rkm = 6371                  # Earth radius in kilometers
  rm = rkm * 1000             # Radius in meters
  dlon_rad = (b[1]-a[1]) * rad_per_deg  # Delta, converted to rad
  dlat_rad = (b[0]-a[0]) * rad_per_deg

  lat1_rad, lon1_rad = a.map! {|i| i * rad_per_deg }
  lat2_rad, lon2_rad = b.map! {|i| i * rad_per_deg }

  a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
  c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

  d = rm * c # Delta in meters
  return (d < 1000 ? d : -1)
end
