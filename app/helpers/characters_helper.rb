module CharactersHelper
  def trapping_label(area)
    if @character.profile.trappings.send(area)
      "<span class='label'> #{@character.profile.trappings.send(area)['title'].gsub(/Right/,'R.').gsub(/Left/,'L.')}</span>"
    else
      '<em>Nothing special</em>'
    end
  end
end