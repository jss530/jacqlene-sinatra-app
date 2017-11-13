require 'rack-flash'

class WineController < ApplicationController
  use Rack::Flash

  get '/wines' do
    if is_logged_in?
      @wines = current_user.wines.all.sort_by {|wine| wine.producer.downcase}
      erb :'/wines/show_wines'
    else
      redirect('/login')
    end
  end

  get '/wines/new' do
    if !is_logged_in?
      redirect('/login')
    else
      @error = session[:error]
      session[:error] = nil

      erb :'/wines/add_wine'
    end
  end

  get '/wines/:id' do

  if !is_logged_in?
    redirect('/login')
  else
    @wine = current_user.wines.find_by(id: params[:id])

    erb :'/wines/single_wine'
  end
end

post '/wines' do
  if is_logged_in?
    @wine = current_user.wines.build(:producer => params[:producer], :wine_name => params[:wine_name], :vintage => params[:vintage],
    :price => params[:price], :quantity => params[:quantity], :notes => params[:notes])
    if @wine.producer != "" && @wine.quantity != "" && @wine.save
      redirect to "/wines/#{@wine.id}"
    else
      session[:error] = "Please enter a producer and quantity."
      redirect('/wines/new')
    end
  else
    redirect to '/login'
  end
end

get '/wines/:id/edit' do
  if is_logged_in?
    if @wine = current_user.wines.find_by(id: params[:id])
      erb :'/wines/edit_wine'
    else
      redirect to '/wines'
    end
  else
    redirect to '/login'
  end
end

patch '/wines/:id' do
  @wine = current_user.wines.find_by(id: params[:id])

  if is_logged_in?
    if @wine.producer != "" && @wine.quantity != ""
      @wine.update(:producer => params[:producer], :wine_name => params[:wine_name], :vintage => params[:vintage],
      :price => params[:price], :quantity => params[:quantity], :notes => params[:notes])
      redirect to "/wines/#{@wine.id}"
    else
      redirect to "/wines/#{@wine.id}/edit"
    end
  else
    redirect to '/login'
  end
end

delete '/wines/:id/delete' do
  if is_logged_in?
    @wine = current_user.wines.find_by(id: params[:id])

    if current_user.wines.include?(@wine)
      @wine.delete
      erb :'/wines/delete_wine'
    else
      redirect to '/wines'
    end
  else
    redirect to '/login'
 end
end

end

# TODO:
# Update your app to ust using the AuthHelpers
# Make sure your checking for logged in all routes that need a logged in user
# Make sure that only the owner of the wine can update or delete the wine
