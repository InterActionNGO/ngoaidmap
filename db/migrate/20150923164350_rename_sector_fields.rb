class RenameSectorFields < ActiveRecord::Migration
  def self.up
    rename_column :sectors, :oec_dac_name, :oecd_dac_name
    rename_column :sectors, :oec_dac_purpose_code, :oecd_dac_purpose_code
  end
end
