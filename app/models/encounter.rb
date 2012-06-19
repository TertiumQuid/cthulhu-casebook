class Encounter
  include MongoMapper::Document
  
  key :title, String, :required => true
  key :text, String, :required => true
  
  many :paths
  
  def play(path_id)
  end
end