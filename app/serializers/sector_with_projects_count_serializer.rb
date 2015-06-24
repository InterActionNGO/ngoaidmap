class SectorWithProjectsCountSerializer < ActiveModel::Serializer
  attributes :type, :id, :name, :projects_count
  def id
    object[:id]
  end
  def name
    object[:name]
  end
  def projects_count
    object[:projects_count]
  end
  def type
    'sectors'
  end
end
