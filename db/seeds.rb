collections = Dir.glob(File.join(File.dirname(__FILE__), '/data/**/*.yml'))

collections.sort.each do |file| 
  collection = YAML.load_file(file)
  collection_name = collection.keys.first
  model_name = collection_name.singularize.camelize
  
  data = collection[collection_name].values
  Kernel.const_get(model_name).collection.insert data
end
