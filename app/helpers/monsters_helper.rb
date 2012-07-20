module MonstersHelper
  def monster_strategy_success(name)
    case params[:id].to_s
    when 'fight'
      "You defeated the #{name} in a horrifying battle."
    when 'escape'
      "You quickly escaped the #{name} with your life."
    when 'stealth'
      "You hid from the #{name} for what seemed like an eternity."
    when 'magic'      
      "You used dark arts to bind the #{name}."
    when 'confront'
      "You put the #{name} to a spectacular end with the power of arcane knowledge"
    end 
  end
  
  def monster_strategy_failure(name)
    case params[:id].to_s
    when 'fight'
      "You suffered soul-crushing defeat fighting the #{name}."
    when 'escape'
      "The #{name} caught you in an instant and scarred you forever."
    when 'stealth'
      "There was no hiding from the #{name} and you paid the price."
    when 'magic'      
      "Your magical pretense leaves you especially vulnerable to the #{name}."
    end    
  end
end