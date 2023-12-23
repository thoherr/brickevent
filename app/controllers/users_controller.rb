# encoding: UTF-8
class UsersController < ApplicationController
  # GET /users/1/edit
  def edit
    get_user
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    get_user

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to events_path, :notice => t('profile_changed') }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  private
  def get_user
    id = params[:id].to_i
    unless current_user.id == id || current_user.is_admin?
      raise 'unauthorized request'
    end
    @user = User.find(id)
  end

  def user_params
    # FIXME: This is just a temporary wild card to get the app running on Raila 4.0
    params.require(:user).permit!
  end
end
