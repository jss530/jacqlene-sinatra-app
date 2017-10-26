require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  get '/' do
    erb :index
  end

  get '/signup' do
    if logged_in?
      redirect('/wines') #PENDING: need to decide where you want to redirect. Their post-login page, most likely
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
      redirect('/wines') #PENDING: need to decide where you want to redirect. Their post-login page, most likely
    end
  end

    get '/login' do
      if logged_in?
        redirect('/wines') #PENDING: need to decide where you want to redirect. Their post-login page, most likely
      else
        erb :'/users/login'
      end
    end

    post '/login' do

    @user = User.find_by(:username => params[:username])
      if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect('/wines') #PENDING: need to decide where you want to redirect. Their post-login page, most likely
      end
    end

    get '/wines' do
      if logged_in?
        @user = User.find(session[:user_id])
        @wines = Wine.all
        erb :'/wines/show_wines'
      else
        redirect('/login')
      end
    end


  helpers do
    def current_user
      User.find(session[:user_id])
    end

    def logged_in?
      !!session[:user_id]
    end
  end

end
