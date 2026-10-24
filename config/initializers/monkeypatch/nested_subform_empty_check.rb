# Active Scaffold decides whether a blank subform row (e.g. the empty "new
# event manager" row in the event form, with its nested new-user form) may be
# ignored by comparing every submitted value with the column default. For
# nested association hashes it keeps using the *outer* class for that lookup,
# so a nested user's `is_admin => "0"` is checked against EventManager, is not
# recognised as the default, and the blank row turns into an invalid new
# record ("Event managers ist ungültig").
#
# This only surfaces with NOT NULL booleans, which render as checkboxes that
# always submit "0"/"1"; nullable booleans rendered as selects submitting "".
#
# The patch resolves the association's class for nested hashes. Same
# technique as unsaved_record.rb (reopen the module in to_prepare).
Rails.application.config.to_prepare do
  module ActiveScaffold::AttributeParams
    def attributes_hash_is_empty?(hash, klass)
      hash.all? do |key, value|
        # convert any possible multi-parameter attributes like 'created_at(5i)' to simply 'created_at'
        column_name = key.to_s.split('(', 2)[0]

        next true if mulitpart_ignored?(key, klass)
        next true if default_value?(column_name, klass, value)

        if params_hash? value
          attributes_hash_is_empty?(value, nested_subform_klass(klass, column_name))
        elsif value.is_a?(Array)
          value.all?(&:blank?)
        else
          value.respond_to?(:empty?) ? value.empty? : false
        end
      end
    end

    private

    def nested_subform_klass(klass, column_name)
      return klass unless klass.respond_to?(:reflect_on_association)

      association = klass.reflect_on_association(column_name.to_sym)
      return klass if association.nil? || association.polymorphic?

      association.klass
    end
  end
end
