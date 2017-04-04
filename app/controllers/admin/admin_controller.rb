module Admin
  class AdminController < ApplicationController
    layout "admin"

    before_filter :authenticate_user!
    before_filter :redirect_non_admins_to_frontend!

    ActiveScaffold.set_defaults do |config| 
      config.ignore_columns.add [:created_at, :updated_at, :lock_version]
    end

    def redirect_non_admins_to_frontend!
      unless current_user.is_admin?
        redirect_to events_url
      end
    end
  end
end
