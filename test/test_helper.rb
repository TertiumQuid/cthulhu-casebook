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
    ['arkham_northside', 'miskatonic_university'].each do |loc|
      docs = YAML.load_file( File.expand_path("../../db/data/encounters/locations/#{loc}.yml", __FILE__) )
      data = docs['encounters'].values
      Encounter.collection.insert data
    end
  end
  
  def load_monsters
    docs = YAML.load_file( File.expand_path('../../db/data/monsters.yml', __FILE__) )
    data = docs['monsters'].values
    Monster.collection.insert data
  end
  
  def load_locations
    docs = YAML.load_file( File.expand_path('../../db/data/locations.yml', __FILE__) )
    data = docs['locations'].values
    Location.collection.insert data
  end

  def load_equipment
    docs = YAML.load_file( File.expand_path('../../db/data/equipment.yml', __FILE__) )
    data = docs['equipment'].values
    Equipment.collection.insert data
  end
  
  def mock_character(character_id=1)
    @controller.session[:character_id] = character_id
  end

  def mock_user(user_id=1)
    @controller.session[:user_id] = user_id
  end
  
  def login!(user=nil, character=nil)
    user ||= User.create(:email => 'char@example.com')    
    mock_user user._id
    character ||= Character.create(:name => 'test', :user_id => user._id)
    mock_character(character._id)
    character
  end
end