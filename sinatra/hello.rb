
require 'active_record'
require 'mysql2'
require 'sinatra'

ActiveRecord::Base.configurations = YAML.load_file('database.yml')
ActiveRecord::Base.establish_connection(:development)

class User < ActiveRecord::Base
end

get '/' do
    @title = "ハローワールド"
    erb :index
end

get '/show-database' do
  user = User.new
  user.email = params[:email]
  user.order_num = params[:order]
  user.save
  erb :index
end
