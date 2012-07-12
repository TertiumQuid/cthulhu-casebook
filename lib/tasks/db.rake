namespace :db do
  desc "Delete and seed the MongoDB guide collection"
  task :reseed => :environment do
    MongoMapperStore::Session.delete_all
    Profile.delete_all    
    Character.delete_all
    User.delete_all
    Gift.delete_all
    Demise.delete_all
    Encounter.delete_all
    Location.delete_all
    Lodging.delete_all    
    Message.delete_all    
    
    Rake::Task["db:seed"].execute
  end
end