namespace :stats do
  desc "Delete and seed the MongoDB guide collection"
  task :challenges => :environment do
    printf "\n"
    printf " Character Traits vs. Challenge Difficulty Stats Table\n"
    printf " ---------------------------------------------------------------------\n"    
    printf " %-10s %-50s\n", 'TRAIT', 'DIFFICULTY'
    printf " %-10s %-5s %-5s %-5s %-5s %-5s %-5s %-5s %-5s %-5s %-5s\n", '       ', 1, 2, 3, 4, 5, 6, 7, 8, 9, 10

    challenge = Challenge.new
    
    20.times do |t|
      val = (t*(5+(t/2)))+1
      tag = Tag.new(:value => val )
      a = []
      10.times do |d|
        challenge.difficulty = d + 1
        a << "#{challenge.send(:chance_of_success, tag)}%"
      end
      val_display = (val < 10 ? "00#{val}" : (val < 100 ? "0#{val}" : val))
      printf " %-10s %-5s %-5s %-5s %-5s %-5s %-5s %-5s %-5s %-5s %-5s\n", val_display, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9]
    end
    printf "\n"    
  end
end