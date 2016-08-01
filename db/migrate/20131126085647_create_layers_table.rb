class CreateLayersTable < ActiveRecord::Migration
  def self.up
    create_table :layers do |t|
      t.string    :title
      t.text      :description
      t.text      :credits
      t.datetime  :date
      t.integer   :min
      t.integer   :max
      t.integer   :units 
      t.boolean   :status
      t.string    :cartodb_table
    end
  end

  def self.down
    drop_table  :layers
  end
end
