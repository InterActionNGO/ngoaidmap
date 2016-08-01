class AddIatiFieldsToSectors < ActiveRecord::Migration
  def self.up
    add_column :sectors, :oec_dac_name, :string
    add_column :sectors, :sector_vocab_code, :string
    add_column :sectors, :oec_dac_purpose_code, :string
  end
  def self.down
    remove_column :sectors, :oec_dac_name
    remove_column :sectors, :sector_vocab_code
    remove_column :sectors, :oec_dac_purpose_code
  end
end
