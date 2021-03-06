require 'rack-flash'

class UserController < ApplicationController
  use Rack::Flash

get '/signup' do
  if is_logged_in?
    redirect('/wines')
  else
    @error = session[:error]
    session[:error] = nil

    erb :'/users/create_user'
  end
end

post '/signup' do
  @user = User.new(username: params[:username], location: params[:location], password: params[:password])

  if @user.username == ""
    redirect('/signup')
  elsif @user.location == ""
    redirect('/signup')
  elsif User.exists?(:username => @user.username)
    session[:error] = "Username already taken. Please try again."
    redirect('/signup')
  end

  if @user.save
    session[:user_id] = @user.id
    redirect('/wines')
  else
    redirect('/signup')
  end
end

  get '/login' do
    if is_logged_in?
      redirect('/wines')
    else
      erb :'/users/login'
    end
  end

  post '/login' do
    user = User.find_by(:username => params[:username])

      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect('/wines')
      else
        redirect('/signup')
      end
  end

  get '/logout' do
    if is_logged_in?
      session.clear
      redirect('/login')
    else
      redirect('/')
    end
  end

end
