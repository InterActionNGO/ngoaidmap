class AddTrigramIndexToOrganizations < ActiveRecord::Migration
  def self.up
      execute <<-SQL
        create index index_organizations_on_name_trigram
        on organizations
        using gin(name gin_trgm_ops);
      SQL
  end

  def self.down
      execute <<-SQL
        drop index 'index_organizations_on_name_trigram'
      SQL
  end
end
