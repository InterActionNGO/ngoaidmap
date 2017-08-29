class HumanitarianScopeType < ActiveRecord::Base
  validates :name, presence: true
  validates :code, presence: true, uniqueness: { case_sensitive: false }

  def self.import(path)
    schema = JSON.load(Rails.root.join(path))

    schema["data"].each { |item| create(item) }
  end
end
