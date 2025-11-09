# fix a bug in module UnsavedRecord from active_scaffold (up to 3.6.20) which makes it incompatible with ruby 3

# see https://stackoverflow.com/questions/17118657/monkey-patching-devise-or-any-rails-gem
# for more information how this monkey patching works

Rails.application.config.to_prepare do
  module ActiveScaffold::UnsavedRecord
    # automatically unsets the unsaved flag
    def save(**)
      super.tap { self.unsaved = false }
    end
  end
end
