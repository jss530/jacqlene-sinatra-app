class WineController < ApplicationController

  get '/wines' do
    if Helpers.is_logged_in?(session)
      @user = User.find(session[:user_id])
      @wines = Wine.all
      erb :'/wines/show_wines'
    else
      redirect('/login')
    end
  end

end
