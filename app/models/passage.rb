require 'active_model/requirement_support'

class Passage
  include MongoMapper::EmbeddedDocument
  include ActiveModel::RequirementSupport
end