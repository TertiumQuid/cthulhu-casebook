ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  def teardown
    MongoMapper.database.collections.each do |c|
      c.remove  
    end
  end

  def load_encounters
    ['arkham', 'miskatonic_university'].each do |loc|
      docs = YAML.load_file( File.expand_path("../../db/data/encounters/#{loc}.yml", __FILE__) )
      data = docs['encounters'].values
      Encounter.collection.insert data
    end
  end
  
  def load_locations
    docs = YAML.load_file( File.expand_path('../../db/data/locations.yml', __FILE__) )
    data = docs['locations'].values
    Location.collection.insert data
  end
  
  def mock_character(character_id=1)
    @controller.session[:character_id] = character_id
  end
  
  def login!
    chr = Character.create(:name => 'test')
    mock_character(chr._id)
    chr
  end
end