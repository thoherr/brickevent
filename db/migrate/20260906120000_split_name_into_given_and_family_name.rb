require Rails.root.join('lib', 'person_name_splitter')

# Splits the free-text `name` column of users and attendees into
# `given_name` and `family_name`. The data split is a best-effort guess
# (see PersonNameSplitter); rows whose split is doubtful are logged so an
# admin can review them in the backend afterwards.
class SplitNameIntoGivenAndFamilyName < ActiveRecord::Migration[8.1]
  TABLES = %i[users attendees].freeze
  BATCH_SIZE = 500

  def up
    TABLES.each do |table|
      add_column table, :given_name, :string
      add_column table, :family_name, :string
    end

    TABLES.each { |table| split_names(table) }

    TABLES.each { |table| remove_column table, :name }
  end

  def down
    TABLES.each { |table| add_column table, :name, :string }

    TABLES.each { |table| join_names(table) }

    TABLES.each do |table|
      remove_column table, :family_name
      remove_column table, :given_name
    end
  end

  private

  def split_names(table)
    quoted_table = connection.quote_table_name(table)
    ambiguous = []
    last_id = 0

    loop do
      rows = connection.select_all(
        "SELECT id, name FROM #{quoted_table} WHERE id > #{last_id.to_i} ORDER BY id LIMIT #{BATCH_SIZE}"
      )
      break if rows.empty?

      rows.each do |row|
        given, family = PersonNameSplitter.split(row['name'])
        ambiguous << "#{table} ##{row['id']}: #{row['name'].inspect} -> #{given.inspect} / #{family.inspect}" if PersonNameSplitter.ambiguous?(row['name'])
        connection.update(
          "UPDATE #{quoted_table} SET given_name = #{connection.quote(given)}, family_name = #{connection.quote(family)} WHERE id = #{row['id'].to_i}"
        )
        last_id = row['id'].to_i
      end
    end

    return if ambiguous.empty?

    say "#{ambiguous.length} #{table} row(s) need manual review of the name split:"
    ambiguous.each { |line| say line, true }
  end

  def join_names(table)
    quoted_table = connection.quote_table_name(table)
    last_id = 0

    loop do
      rows = connection.select_all(
        "SELECT id, given_name, family_name FROM #{quoted_table} WHERE id > #{last_id.to_i} ORDER BY id LIMIT #{BATCH_SIZE}"
      )
      break if rows.empty?

      rows.each do |row|
        name = [row['given_name'], row['family_name']].reject { |part| part.nil? || part.strip.empty? }.join(' ')
        connection.update(
          "UPDATE #{quoted_table} SET name = #{connection.quote(name.empty? ? nil : name)} WHERE id = #{row['id'].to_i}"
        )
        last_id = row['id'].to_i
      end
    end
  end
end
