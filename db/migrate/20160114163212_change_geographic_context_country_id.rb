class ChangeGeographicContextCountryId < ActiveRecord::Migration
  def change
    change_column :sites, :geographic_context_country_id, :string
  end
end
