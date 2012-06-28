require 'test_helper'

class LocationTest < ActiveModel::TestCase
  def test_passage_to
    location = Location.new
    passage = Passage.new(:_id => 'miskatonic_university')
    location.passages << passage
    assert_nil location.passage_to('arkham_easttown'), 'expected nil without passage'
    assert_equal passage, location.passage_to('miskatonic_university'), 'expected matching passage'
  end  
end