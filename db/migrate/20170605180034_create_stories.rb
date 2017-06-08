class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :name
      t.text :story, null: false, limit: 2500
      t.string :organization
      t.string :email
      t.attachment :image
      t.boolean :published, null: false, default: false
      t.boolean :reviewed, null: false, default: false
      t.integer :last_reviewed_by_id
      t.timestamp :last_reviewed_at
      t.timestamps null: false
    end
    add_index :stories, :name
    add_index :stories, :email
  end
end
