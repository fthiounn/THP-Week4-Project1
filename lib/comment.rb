class Comment
	attr_accessor :id, :content
	def initialize(id,content)
		@id = id
		@content = content
	end
	def self.all
		comment_array = [] #on initialise un array vide
	 	CSV.read("./db/comment.csv").each do |line|
		 	comment_array << Comment.new(line[0],line[1])
		end
 		return comment_array
	end
	def save
	  CSV.open("./db/comment.csv", "ab") do |csv|
	    csv << [@id,@content]
	  end
	end
	def self.all_with_id (id)
		return self.all.select {|comment| comment.id.to_i == id}
	end
end