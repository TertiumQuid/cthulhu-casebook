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
    docs = YAML.load_file( File.expand_path('../../db/data/encounters/arkham.yml', __FILE__) )
    data = docs['encounters'].values
    Encounter.collection.insert data
  end
  
  def load_locations
    docs = YAML.load_file( File.expand_path('../../db/data/locations.yml', __FILE__) )
    data = docs['locations'].values
    Location.collection.insert data
  end
  
  def mock_character(character_id=1)
    @controller.session[:character_id] = character_id
  end
end