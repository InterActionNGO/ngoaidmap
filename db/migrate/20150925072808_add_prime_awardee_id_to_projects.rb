class AddPrimeAwardeeIdToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :prime_awardee_id, :integer
    add_index :projects, :prime_awardee_id
  end

  def self.down
    remove_column :projects, :prime_awardee_id
  end
end
