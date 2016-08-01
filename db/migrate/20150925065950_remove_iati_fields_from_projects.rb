class RemoveIatiFieldsFromProjects < ActiveRecord::Migration
  def self.up
    remove_column :projects, :project_reach_actual_start_date
    remove_column :projects, :project_reach_target_start_date
    remove_column :projects, :project_reach_actual_end_date
    remove_column :projects, :project_reach_target_end_date
    remove_column :projects, :project_reach_type
    remove_column :projects, :project_reach_type_code
    remove_column :projects, :project_reach_measure
    remove_column :projects, :project_reach_measure_code
    remove_column :projects, :project_reach_description
  end

  def self.down
    add_column :projects, :project_reach_actual_start_date, :date
    add_column :projects, :project_reach_target_start_date, :date
    add_column :projects, :project_reach_actual_end_date, :date
    add_column :projects, :project_reach_target_end_date, :date
    add_column :projects, :project_reach_type, :string, :default => 'Output'
    add_column :projects, :project_reach_type_code, :integer, :default => 1
    add_column :projects, :project_reach_measure, :string, :default => 'Unit'
    add_column :projects, :project_reach_measure_code, :integer, :default => 1
    add_column :projects, :project_reach_description, :text
  end
end
