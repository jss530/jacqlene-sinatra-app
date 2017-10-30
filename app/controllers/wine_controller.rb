class WineController < ApplicationController

  get '/wines' do
    if Helpers.is_logged_in?(session)
      @user = User.find(session[:user_id])
      @wines = Wine.all.sort_by {|wine| wine.producer.downcase}
      erb :'/wines/show_wines'
    else
      redirect('/login')
    end
  end

  get '/wines/new' do #pending
    if !Helpers.is_logged_in?(session) #may need to change
      redirect('/login')
    else
      erb :'/wines/add_wine'
    end
  end

  get '/wines/:id' do #pending

  if !Helpers.is_logged_in?(session) #may need to change
    redirect('/login')
  else
    @wine = Wine.find(params[:id])
    erb :'/wines/single_wine'
  end
end

post '/wines' do #pending
  @wine = Wine.new(:producer => params[:producer], :wine_name => params[:wine_name], :vintage => params[:vintage],
  :price => params[:price], :quantity => params[:quantity], :notes => params[:notes])

  if @wine.producer != "" && @wine.quantity != ""
    @wine = Wine.create(:producer => params[:producer], :wine_name => params[:wine_name], :vintage => params[:vintage],
    :price => params[:price], :quantity => params[:quantity], :notes => params[:notes])
    @wine.save
    current_user.wines << @wine
    redirect to "/wines/#{@wine.id}"
  else
    redirect('/wines/new')
  end
end

get '/wines/:id/edit' do #pending
  @wine = Wine.find_by(id: params[:id])

  if !Helpers.is_logged_in? #may need to change
    redirect('/login')
  elsif current_user.wines.include?(@wine)
    erb :'/wines/single_wine'
  else
    redirect('/wines')
  end
end

patch '/wines/:id' do #pending
  @wine = Wine.find_by(id: params[:id])

  if @wine.producer != "" && @wine.quantity != ""
    @wine.update(:producer => params[:producer], :wine_name => params[:wine_name], :vintage => params[:vintage],
    :price => params[:price], :quantity => params[:quantity], :notes => params[:notes])
    redirect to "/wines/#{@wine.id}"
  else
    redirect to "/wines/#{@wine.id}/edit"
  end
end

delete '/wines/:id/delete' do #pending
  if Helpers.is_logged_in? #may need to change
    @wine = Wine.find_by(id: params[:id])

    if current_user.wines.include?(@wine)
      @wine.delete
      redirect to '/wines'
    else
      redirect to '/wines'
    end
 end
end

end
