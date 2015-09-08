class CountriesSummingSerializer < ActiveModel::Serializer
  attributes :id, :type, :name, :uid, :total_projects
  def id
    object["g0"]
  end
  def type
    "Geolocations"
  end
  def name
    object["country_name"]
  end
  def uid
    object["g0"]
  end
  def total_projects
    object["total_projects"]
  end
end
