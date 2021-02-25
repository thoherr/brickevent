# encoding: UTF-8
class UsersController < ApplicationController
  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to events_path, :notice => t('profile_changed') }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  private
  def user_params
    # FIXME: This is just a temporary wild card to get the app running on Raila 4.0
    params.require(:user).permit!
  end
end
