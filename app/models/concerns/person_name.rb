# frozen_string_literal: true

# Shared behaviour for models that carry a person's name split into
# `given_name` and `family_name`.
module PersonName
  extend ActiveSupport::Concern

  # "Given Family" for display purposes.
  def full_name
    [given_name, family_name].reject(&:blank?).join(' ')
  end

  # "Family, Given" for sorting and lists.
  def sortable_name
    [family_name, given_name].reject(&:blank?).join(', ')
  end
end
