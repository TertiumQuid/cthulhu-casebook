class HelpController < ApplicationController
  before_filter :require_template, :only => [:show]
  
  def show
    render :template => @template
  end
  
  private
  
  def require_template
    @template = "help/#{params[:id]}"
    redirect_to root_path and return unless template_exists?(params[:id], "help")
  end
end