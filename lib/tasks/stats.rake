namespace :stats do
  desc "Show location comparison table"
  task :location => :environment do
    printf "\n"
    printf " Locations\n"
    printf " ---------------------------------------------------------------------\n"    
    printf " %-30s %-15s %-15s %-15s\n", 'LOCATION', 'ENCOUNTERS', 'MONSTERS', 'PASSAGES'
    
    monster_count = Monster.count
    encounter_count = Encounter.count  
    
    Location.all.each do |loc|  
      cnt = Encounter.find_location(loc._id).count.to_f
      ecnt = ((cnt / encounter_count.to_f) * 100.0).round(0)
      encounters = "#{cnt} (#{ecnt}%)"
      
      cnt = Monster.find_location(loc._id).count.to_f
      mcnt = ((cnt / monster_count.to_f) * 100.0).round(0)
      monsters = "#{cnt} (#{mcnt}%)"
      printf " %-30s %-15s %-15s %-15s\n", loc.short_name, encounters, monsters, loc.passages.size
    end
  end
  
  desc "Show contest mechanic percentages"
  task :contest => :environment do
    printf "\n"
    printf " Character Traits vs. Contest Difficulty Stats Table\n"
    printf " ---------------------------------------------------------------------\n"    
    printf " %-10s %-50s\n", 'TRAIT', 'DIFFICULTY'
    printf " %-10s %-5s %-5s %-5s %-5s %-5s %-5s %-5s %-5s %-5s %-5s\n", '       ', 1, 2, 3, 4, 5, 6, 7, 8, 9, 10

    instance = Challenge.new
    
    20.times do |t|
      val = (t*(5+(t/2)))+1
      tag = Tag.new(:value => val )
      a = []
      10.times do |d|
        instance.difficulty = d + 1
        a << "#{instance.send(:chance_of_success, tag)}%"
      end
      val_display = (val < 10 ? "00#{val}" : (val < 100 ? "0#{val}" : val))
      printf " %-10s %-5s %-5s %-5s %-5s %-5s %-5s %-5s %-5s %-5s %-5s\n", val_display, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9]
    end
    printf "\n"    
  end
end