class ImportunitiesController < ApplicationController
  def create
    @importunity = Importunity.request(current_user, params[:user_id])
    render :show
  end
  
  def accept
    current_user.importunity.accept!(params[:id])
    redirect_to friends_path
  end
  
  def reject
    current_user.importunity.reject!(params[:id])
    redirect_to friends_path
  end
end