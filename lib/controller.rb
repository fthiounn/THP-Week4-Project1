class ApplicationController < Sinatra::Base

get '/' do
  erb :index
end

get '/gossips/new/' do
	erb :new_gossip
end

end