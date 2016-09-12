class AddBudgetUsdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :budget_usd, :decimal, scale: 2, precision: 13
  end
end
