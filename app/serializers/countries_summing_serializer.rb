class CountriesSummingSerializer < ActiveModel::Serializer
  cache key: "main_api_country_summing", expires_in: 3.hours
  attributes :type, :name, :uid, :total_projects
  def id
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
