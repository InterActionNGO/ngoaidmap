class AddIatiProjectFields < ActiveRecord::Migration
  def self.up
    add_column :projects, :budget_currency, :string
    add_column :projects, :budget_value_date, :date
    add_column :projects, :target_project_reach, :integer
    add_column :projects, :actual_project_reach, :integer
    add_column :projects, :project_reach_unit, :string
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

  def self.down
    remove_column :projects, :budget_currency
    remove_column :projects, :budget_value_date
    remove_column :projects, :target_project_reach
    remove_column :projects, :actual_project_reach
    remove_column :projects, :project_reach_unit
    remove_column :projects, :project_reach_actual_start_date
    remove_column :projects, :project_reach_target_start_date
    remove_column :projects, :project_reach_actual_end_date
    remove_column :projects, :project_reach_target_end_date
    remove_column :projects, :project_reach_type, :string
    remove_column :projects, :project_reach_type_code
    remove_column :projects, :project_reach_measure
    remove_column :projects, :project_reach_measure_code
    remove_column :projects, :project_reach_description
  end
end
