module Admin
  class AdminController < ApplicationController
    layout "admin"

    before_filter :authenticate_user!

    ActiveScaffold.set_defaults do |config| 
      config.ignore_columns.add [:created_at, :updated_at, :lock_version]
    end

  end
end
