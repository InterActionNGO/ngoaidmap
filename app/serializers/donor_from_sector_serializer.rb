class DonorFromSectorSerializer < ActiveModel::Serializer
  cache key: "main_api_donors_from_sectors", expires_in: 3.hours
  attributes :type, :id, :name
  def id
    object[:id]
  end
  def name
    object[:name]
  end
  def type
    'donors'
  end
end
