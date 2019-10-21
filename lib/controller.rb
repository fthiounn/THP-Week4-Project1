#Controller de notre appli Sinatra

class ApplicationController < Sinatra::Base

	get '/' do
	  erb :index, locals: {gossips: Gossip.all}
	end

	get '/gossips/new/' do
		erb :new_gossip
	end

	post '/gossips/new/' do
	  Gossip.new(params["gossip_author"], params["gossip_content"]).save
	  redirect '/'
	end

	get '/gossips/:id' do

		erb :gossip, locals: {gossip: Gossip.all[params[:id].to_i], id: params[:id].to_i}

	end

end