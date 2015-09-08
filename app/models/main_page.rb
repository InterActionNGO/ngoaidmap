# == Schema Information
#
# Table name: pages
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  body        :text
#  site_id     :integer
#  published   :boolean
#  permalink   :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  parent_id   :integer
#  order_index :integer
#

class MainPage < Page

  #default_scope where(site_id: nil)

  def self.model_name
    Page.model_name
  end

end
