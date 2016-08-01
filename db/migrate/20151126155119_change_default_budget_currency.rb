class ChangeDefaultBudgetCurrency < ActiveRecord::Migration
  def self.up
    change_column :projects, :budget_currency, :string, :default => "USD"
  end

  def self.down
  end
end
