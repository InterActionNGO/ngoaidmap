class AddImageUrlToMediaResources < ActiveRecord::Migration
  def change
    add_column :media_resources, :external_image_url, :string
  end
end
