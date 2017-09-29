class CreateIdentifiers < ActiveRecord::Migration
  def self.up
    create_table :identifiers do |t|
      t.string :identifier, :null => false
      t.integer :assigner_org_id, :null => false
      t.references :identifiable, :index => true, :polymorphic => true
      t.timestamps
    end
  end

  def self.down
    drop_table :identifiers
  end
end
