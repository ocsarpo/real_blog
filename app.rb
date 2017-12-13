require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/flash'
require 'data_mapper' # metagem, requires common plugins too.
require './model.rb'

set :bind, '0.0.0.0'

enable :sessions

get '/' do
  @post = Post.all.reverse  #최신 순
  erb :index
end

get '/write' do
  Post.create(
    :writer => params["writer"],
    :title => params["title"],
    :body => params["content"]
  )
  redirect to '/'
end

get '/signup' do
  erb :signup
end

get '/register' do
  author = params[:author]
  is_admin = ""
  puts author
  if author == "admin"
    is_admin = true
  else
    is_admin = false
  end
  User.create(
    :email => params["email"],
    :password => params["password"],
    :is_admin => is_admin
  )
  redirect to '/'
end

get '/admin' do
  # 모든 유저를 불러와
  # admin.erb에서 모든 유저를 보여준다
  @users = User.all
  erb :admin
end
get '/change_session' do
  userdata = User.get(params["id"])
  if session[:email] != userdata.email
    @UserInfo = User.get(params["id"])
    erb :change
  else
    flash[:error] = "자기자신 권한 변경"
    redirect to '/admin'
  end
end

get '/change' do
  userdata = User.get(params["id"])
  author = params["author"]
  if author == "admin"
    userdata.update(:is_admin => true)
  else
    userdata.update(:is_admin => false)
  end
  redirect to '/admin'
end

get '/login' do
  erb :login
end

get '/login_session' do
  @message = ""
  inputed = User.first(:email => params["email"])
  if inputed
    if inputed.password == params["password"]
      session[:email] = params["email"]
      @message = "로그인 되었음"
    else
      @message = "비번틀림"
    end
  else
    @message = "그런 이메일 없음"
  end
  erb :login_session
end

get '/logout' do
  session.clear
  redirect to '/'
end
