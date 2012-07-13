class Tag
  include MongoMapper::EmbeddedDocument

  key :value, String, :required => true  
  
  def set(v)
    if numeric?(v)
      self.value = [(value || 0).to_i + v.to_i, 0].max
    else
      self.value = v
    end
  end
  
  def numeric?(v=nil)
    v ||= value
    true if Integer(v) rescue false
  end
  
  def count
    value.to_i if numeric?
  end  
end