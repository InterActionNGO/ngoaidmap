class ChangeProjectReachTypeColumns < ActiveRecord::Migration
  def self.up
    change_column :projects, :target_project_reach, :float
    change_column :projects, :actual_project_reach, :float
  end

  def self.down
    change_column :projects, :target_project_reach, :integer
    change_column :projects, :actual_project_reach, :integer
  end
end
