# encoding: UTF-8
class UsersController < ApplicationController
  # GET /users/1/edit
  def edit
    load_user
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    load_user

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

  def load_user
    @user = User.find(params[:id])
    raise 'Unauthorized request' unless authorized?(@user)
  end

  def user_params
    params.require(:user).permit(:email, :name, :phone, :nickname, :address)
  end
end
