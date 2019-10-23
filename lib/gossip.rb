#Cette classe représente un gossip, elle est définie par son auteur, son contenu et sa place dans le fichier csv
class Gossip
	attr_accessor :author, :content
	def initialize (author, content)
		@author = author
		@content = content
	end
	#sauvegarde l'instance dans le fichier csv
	def save
	  CSV.open("./db/gossip.csv", "ab") do |csv|
	    csv << [@author, @content]
	  end
	end
	#renvoie une liste de tous les gossip
	def self.all
  	gossip_array = [] #on initialise un array vide
	 	CSV.read("./db/gossip.csv").each do |line|
		 	gossip_array << Gossip.new(line[0],line[1])
		end

 		return gossip_array
	end
	#renvoie un gossip à un id donné
	def self.find(id)
		return Gossip.all[id]
	end
	#sauvegarde en memoire la modification du gossip (en sauvegardant sa position dans le fichier csv)
	def self.update(author, content, id)
		gossip_array = self.all
		gossip_array[id.to_i].content = content
		gossip_array[id.to_i].author = author
		#erase the csv file
		File.open("./db/gossip.csv", 'w') {|file| file.truncate(0) }
		#rewrite the file with the modif
		gossip_array.each do |gossip|
			gossip.save
		end	
	end
end