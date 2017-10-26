class UserController < ApplicationController

  get '/signup' do
    if logged_in?
      redirect('/') #PENDING: need to decide where you want to redirect. Their post-login page, most likely
    else
      erb :'/users/create_user'
    end
  end

  post '/signup' do
    @user = User.create(username: params[:username], location: params[:location], password: params[:password])

    if @user.username == ""
      redirect('/signup')
    elsif @user.location == ""
      redirect('/signup')
    elsif @user.save == false
      redirect('/signup')
    else
      @user.save
      logged_in? == true
      session[:user_id] = @user.id
      redirect('/') #PENDING: need to decide where you want to redirect. Their post-login page, most likely
    end
  end

    get '/login' do
      if logged_in?
        redirect('/') #PENDING: need to decide where you want to redirect. Their post-login page, most likely
      else
        erb :'/users/login'
      end
    end

    post '/login' do

    @user = User.find_by(:username => params[:username])
      if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect('/') #PENDING: need to decide where you want to redirect. Their post-login page, most likely
      end
    end

end
