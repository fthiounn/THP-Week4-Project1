#Cette classe gere les commentaires. les objets commentaires sont liés aux gossip par leur ID
class Comment
	attr_accessor :id, :content
	def initialize(id,content)
		@id = id
		@content = content
	end
	#cette fonction nous renvoie un array d'objets comment avec tous les commentaires stockes dans le fichier csv
	def self.all
		comment_array = [] #on initialise un array vide
	 	CSV.read("./db/comment.csv").each do |line|
		 	comment_array << Comment.new(line[0],line[1])
		end
 		return comment_array
	end
	#cette fonction sauvegarde en mémoire le commentaire en question
	def save
	  CSV.open("./db/comment.csv", "ab") do |csv|
	    csv << [@id,@content]
	  end
	end
	#cette fonction trie le tableau d'objet obtenu dans la fonction self.all pour obtenir les commentaires liés a une ID
	def self.all_with_id (id)
		return self.all.select {|comment| comment.id.to_i == id}
	end
end