require 'test_helper'

class ApplicationControllerCharacterSupportTest < ActionController::TestCase
  tests ApplicationController
  
  def test_current_character_id
    assert_nil @controller.current_character_id, 'expected no default character id in session'
    @controller.session[:character_id] = 1    
    assert_equal 1, @controller.current_character_id, 'expected character id from session'
  end
  
  def test_current_character
    assert_nil @controller.current_character, 'expected no default character'    
    
    character = Character.create!(:name => 'test')
    @controller.session[:character_id] = character._id
    assert_equal character, @controller.current_character, 'expected character from stored session character id'    
  end
  
  def test_has_character
    assert_equal false, @controller.has_character?, 'expected no character without character id'
    @controller.session[:character_id] = 1    
    assert_equal true, @controller.has_character?, 'expected no character with session character id'
  end  
  
  def test_authenticate_character
    @controller.authenticate_character(1)
    assert_equal 1, @controller.current_character_id, 'expected current character id set'
  end
  
  def test_requested_new_character_path
    assert_equal false, @controller.requested_new_character_path?, 'expected no character path by default'
    
    @request.path = new_character_path
    assert_equal true, @controller.requested_new_character_path?, 'expected character path from new character request'
    
    @request.request_method = 'post'
    @request.path = character_path    
    assert_equal true, @controller.requested_new_character_path?, 'expected character path from create character request'
  end
end