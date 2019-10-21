#Controller de notre appli Sinatra

class ApplicationController < Sinatra::Base
	#Page d'acceuil ou on liste les gossips
	get '/' do
	  erb :index, locals: {gossips: Gossip.all}
	end
	#page de creation d'un nouveau gossip
	get '/gossips/new' do
		erb :new_gossip
	end
	#traitement du formulaire nouvreau gossip pour la creation de gossip
	post '/gossips/new' do
	  Gossip.new(params["gossip_author"], params["gossip_content"]).save
	  redirect '/'
	end
	# affichage dynamique du gossip par ID
	get '/gossips/:id' do
		erb :gossip, locals: {gossip: Gossip.all[params[:id].to_i], id: params[:id].to_i, comments:Comment.all_with_id(params[:id].to_i)}
	end
	# ajout d'un commentaire lié a un gossip
	post '/gossips/:id' do
		Comment.new(params[:id], params["gossip_comment"]).save
		#reload de la page
		erb :gossip, locals: {gossip: Gossip.all[params[:id].to_i], id: params[:id].to_i, comments:Comment.all_with_id(params[:id].to_i)}
	end
	#Page de modification de gossip
	get '/gossips/:id/edit' do
		erb :edit, locals: {gossip: Gossip.all[params[:id].to_i], id: params[:id].to_i}
	end
	#traitement des données du formulaire de modification de gossip
	post '/gossips/:id/edit' do
		Gossip.update(params["gossip_author"], params["gossip_content"],params[:id].to_i)
		redirect '/'
	end

end