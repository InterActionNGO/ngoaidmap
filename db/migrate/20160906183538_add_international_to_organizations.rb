class AddInternationalToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :international, :boolean
  end
end
