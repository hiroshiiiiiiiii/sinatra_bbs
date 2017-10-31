require 'active_record'
require 'mysql2'
require 'sinatra'
require 'sinatra/reloader'

ActiveRecord::Base.establish_connection(
  adapter: 'mysql2',
  database: 'world',
  host: 'localhost',
  username: 'root',
  password: 'S=v7p2SkVjt4]eW,',
  encoding: 'utf8'
)

class User < ActiveRecord::Base
end

class Comment < ActiveRecord::Base
end

helpers do
  def link_to(txt, url)
    %Q(<a href="#{url}">#{txt}</a>)
  end

  def validates_presence_of(data1,data2)
    error_message = "名前、またはコメントが未入力です。"
    if data1 = "" || data2 = ""
      puts error_message
    end
  end
end

get '/' do
  puts "[DEBUG] env['REMOTE_ADDR']" + request.env['REMOTE_ADDR']
  puts "[DEBUG] request.remote_ip:" + request.ip
  puts "[DEBUG] @env[\"HTTP_X_REAL_IP\"]" + @env["HTTP_X_REAL_IP"]
  @title = "Can you see the text below? If not, you gotta check yeild function!"
  request.user_agent
  erb :index_trial
end

get '/home' do
  @title = "home"
  erb :home
end

get '/comments' do
  request.user_agent
  @ua = params[:user_agent]
  @comments = Comment.all.order('created_at DESC')
  @title = "My Sinatra BBS"
  erb :index2
end

get '/comments/new_post' do
  @title = "new comment"
  request.user_agent
  erb :new_post
end

post '/comments/new_post/post' do
  puts "[DEBUG] name:" +  request[:name]
  puts "[DEBUG] message:" + request[:message]
  puts "[DEBUG] env['HTTP_X_REAL_IP']" + @env['HTTP_X_REAL_IP']
  if request[:name]=="" || request[:message]==""
    @error_message = "名前、またはコメントが未入力です。"
    erb :new_post
  else
    Comment.create({
      :name => request[:name],
      :message => request[:message],
      :created_at => Time.now,
      :ip_address => @env['HTTP_X_REAL_IP'],
      :user_agent => request.user_agent
      })
      redirect '/comments'
  end
end
