class AddCurrencyToDonations < ActiveRecord::Migration
  def change
      add_column :donations, :amount_usd, :decimal, scale: 2, precision: 13
      add_column :donations, :amount_currency, :string
      change_column :donations, :amount, :decimal, scale: 2, precision: 13
  end
end
