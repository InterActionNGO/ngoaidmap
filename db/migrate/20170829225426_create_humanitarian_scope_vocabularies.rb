class CreateHumanitarianScopeVocabularies < ActiveRecord::Migration
  def change
    create_table :humanitarian_scope_vocabularies do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.string :url

      t.timestamps null: false

      t.index :code, unique: true
      t.index :name, unique: true
    end
  end
end
