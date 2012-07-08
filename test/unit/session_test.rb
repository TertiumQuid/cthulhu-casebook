require 'test_helper'

class SessionTest < ActiveModel::TestCase
  def setup
    @old = MongoMapperStore::Session.create(:created_at => (Session::LENGTH * 60 + 1).minutes.ago)
    @new = MongoMapperStore::Session.create(:created_at => (Session::LENGTH * 60 - 1).minutes.ago)
  end
  
  def test_expired
    assert_equal 1, Session.expired.count, 'expected only one expired session'
    assert_equal @old.created_at.to_i, Session.expired.first.created_at.to_i, 'expected found expired session to match fixture'
  end
  
  def test_underlying_collections
    assert_equal Session.first._id.to_s, MongoMapperStore::Session.first._id.to_s, 'expected models to have same underlying collection'
  end
  
  def test_sweep
    assert_difference ['MongoMapperStore::Session.count','Session.count'], -1, 'expected deletion in both collection classes' do
      Session.sweep
    end
  end  
end