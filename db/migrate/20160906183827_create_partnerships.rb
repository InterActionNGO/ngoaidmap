class CreatePartnerships < ActiveRecord::Migration
  def change
    create_table :partnerships do |t|
      t.integer :partner_id, null: false
      t.integer :project_id, null: false

      t.timestamps null: false
    end
  end
end
