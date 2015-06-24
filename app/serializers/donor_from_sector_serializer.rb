class DonorFromSectorSerializer < ActiveModel::Serializer
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
