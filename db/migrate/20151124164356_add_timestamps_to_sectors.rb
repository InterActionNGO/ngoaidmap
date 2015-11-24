class AddTimestampsToSectors < ActiveRecord::Migration
  def change
    change_table(:sectors) { |t| t.timestamps }
  end
end
