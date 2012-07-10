module EncountersHelper
  def fixed_encounters
    @encounters.blank? ? [] : @encounters.select { |e| e.type == 'fixed' && e.available_for?(current_character) }
  end

  def random_encounters
    @encounters.blank? ? [] : @encounters.select { |e| e.type == 'random' }
  end
  
  def plot_encounters
    @encounters.blank? ? [] : @encounters.select { |e| e.type == 'plot' && e.available_for?(current_character) }
  end  
end