class UpdateOrganizationFields < ActiveRecord::Migration
  def change
    add_column :organizations, :acronym, :string
    add_column :organizations, :membership_add_date, :date
    add_column :organizations, :membership_drop_date, :date
    add_column :organizations, :budget_currency, :string
    add_column :organizations, :budget_usd, :decimal, scale: 2, precision: 13
    add_column :organizations, :budget_fiscal_year, :date
    add_column :organizations, :hq_address2, :string
    add_column :organizations, :donation_address2, :string
  end
end
