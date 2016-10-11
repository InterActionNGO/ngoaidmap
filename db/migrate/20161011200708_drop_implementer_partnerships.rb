class DropImplementerPartnerships < ActiveRecord::Migration
  def change
    drop_table :implementer_partnerships do |t|
      t.integer :project_id, null: false
      t.integer :implementer_id, null: false

      t.timestamps null: false
    end
  end
end
