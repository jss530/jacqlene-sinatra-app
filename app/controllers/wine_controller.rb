require 'rack-flash'

class WineController < ApplicationController
  use Rack::Flash

  get '/wines' do
    if Helpers.is_logged_in?(session)
      @user = User.find(session[:id])
      @wines = @user.wines.all.sort_by {|wine| wine.producer.downcase}
      erb :'/wines/show_wines'
    else
      redirect('/login')
    end
  end

  get '/wines/new' do
    if !Helpers.is_logged_in?(session)
      redirect('/login')
    else
      @error = session[:error]
      session[:error] = nil

      erb :'/wines/add_wine'
    end
  end

  get '/wines/:id' do

  if !Helpers.is_logged_in?(session)
    redirect('/login')
  else
    @wine = Wine.find(params[:id])

    erb :'/wines/single_wine'
  end
end

post '/wines' do
  @wine = Wine.new(:producer => params[:producer], :wine_name => params[:wine_name], :vintage => params[:vintage],
  :price => params[:price], :quantity => params[:quantity], :notes => params[:notes])

  if @wine.producer != "" && @wine.quantity != ""
    @wine = Wine.create(:producer => params[:producer], :wine_name => params[:wine_name], :vintage => params[:vintage],
    :price => params[:price], :quantity => params[:quantity], :notes => params[:notes])
    @wine.save
    Helpers.current_user(session).wines << @wine
    redirect to "/wines/#{@wine.id}"
  else
    session[:error] = "Please enter a producer and quantity."
    redirect('/wines/new')
  end
end

get '/wines/:id/edit' do
  @wine = Wine.find_by(id: params[:id])

  if !Helpers.is_logged_in?(session)
    redirect('/login')
  elsif Helpers.current_user(session).wines.include?(@wine)
    erb :'/wines/edit_wine'
  else
    redirect('/wines')
  end
end

patch '/wines/:id' do
  @wine = Wine.find_by(id: params[:id])

  if @wine.producer != "" && @wine.quantity != ""
    @wine.update(:producer => params[:producer], :wine_name => params[:wine_name], :vintage => params[:vintage],
    :price => params[:price], :quantity => params[:quantity], :notes => params[:notes])
    redirect to "/wines/#{@wine.id}"
  else
    redirect to "/wines/#{@wine.id}/edit"
  end
end

delete '/wines/:id/delete' do
  if Helpers.is_logged_in?(session)
    @wine = Wine.find_by(id: params[:id])

    if Helpers.current_user(session).wines.include?(@wine)
      @wine.delete
      erb :'/wines/delete_wine'
    else
      redirect to '/wines'
    end
 end
end

end
