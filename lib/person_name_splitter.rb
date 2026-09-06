# frozen_string_literal: true

# Splits a single free-text person name into given name and family name.
#
# Rules:
# * blank                -> [nil, nil]
# * "Family, Given"      -> split at the first comma
# * "Given Family"       -> last whitespace token is the family name,
#                           everything before it is the given name
# * "Single"             -> given name only
#
# Used by the migration that splits the former `name` column and available
# for future imports.
module PersonNameSplitter
  MANY_TOKENS = 4

  # Returns [given_name, family_name]; either part may be nil.
  def self.split(name)
    return [nil, nil] if name.nil? || name.strip.empty?

    text = name.strip
    if text.include?(',')
      family, given = text.split(',', 2).map { |part| part.strip }
      return [presence(given), presence(family)]
    end

    tokens = text.split(/\s+/)
    return [tokens.first, nil] if tokens.length == 1

    [tokens[0..-2].join(' '), tokens.last]
  end

  # True when the split result is a guess worth reviewing manually:
  # a single token or an unusually long name without a comma.
  def self.ambiguous?(name)
    return false if name.nil? || name.strip.empty?

    text = name.strip
    return false if text.include?(',')

    count = text.split(/\s+/).length
    count == 1 || count >= MANY_TOKENS
  end

  def self.presence(value)
    value.nil? || value.empty? ? nil : value
  end
  private_class_method :presence
end
