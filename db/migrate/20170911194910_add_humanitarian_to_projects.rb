class AddHumanitarianToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :humanitarian, :boolean, null: false, default: false
  end
end
