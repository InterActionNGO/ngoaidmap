class CreateHumanitarianScopeTypes < ActiveRecord::Migration
  def change
    create_table :humanitarian_scope_types do |t|
      t.string :code, null: false
      t.string :name, null: false

      t.timestamps null: false

      t.index :code, unique: true
      t.index :name, unique: true
    end
  end
end
