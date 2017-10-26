class UserController < ApplicationController

  get '/signup' do
    if is_logged_in?
      redirect('/') #PENDING: need to decide where you want to redirect. Their post-login page, most likely
    else
      erb :'/users/create_user'
    end
  end

end
