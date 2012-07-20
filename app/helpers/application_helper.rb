module ApplicationHelper
  def articleize(text)
    text[0] == 'A' ? "An" : 'A'
  end
end
