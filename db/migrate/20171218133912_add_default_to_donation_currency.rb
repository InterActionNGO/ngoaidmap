class AddDefaultToDonationCurrency < ActiveRecord::Migration
  def change
    change_column :donations, :amount_currency, :string, default: 'USD'
  end
end
