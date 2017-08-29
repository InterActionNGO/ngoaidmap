class CreateHumanitarianScopes < ActiveRecord::Migration
  def change
    create_table :humanitarian_scopes do |t|
      t.integer :project_id, null: false
      t.integer :humanitarian_scope_type_id, null: false
      t.integer :humanitarian_scope_vocabulary_id, null: false
      t.string :vocabulary_uri
      t.string :code, null: false
      t.string :narrative

      t.timestamps null: false

      t.index :project_id

      t.foreign_key :projects, on_delete: :cascade
      t.foreign_key :humanitarian_scope_types, on_delete: :restrict
      t.foreign_key :humanitarian_scope_vocabularies, on_delete: :restrict
    end
  end
end
