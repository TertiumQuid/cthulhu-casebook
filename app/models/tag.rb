class Tag
  include MongoMapper::EmbeddedDocument

  key :value, String, :required => true  
  
  def set(v)
    if numeric?(v)
      self.value = (value || 0).to_i + v.to_i
    else
      self.value = v
    end
  end
  
  private
  
  def numeric?(v=nil)
    v ||= value
    true if Integer(v) rescue false
  end 
end