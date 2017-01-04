class RemoveDuplicateFieldsFromSectors < ActiveRecord::Migration
  def change
      remove_column :sectors, :oec_dac_name
      remove_column :sectors, :oec_dac_purpose_code
  end
end
