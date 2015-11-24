class GeolocationPreviewSerializer < ActiveModel::Serializer
  cache key: "main_api_geolocation_preview", expires_in: 3.hours
  attributes :id, :vocab_id, :name, :center_latitude, :center_longitude, :country_iso2_code, :country_name, :country_vocab_id, :data_provider, :admin_level, :adm0_relation_vocab_id, :adm1_relation_vocab_id, :adm2_relation_vocab_id, :adm3_relation_vocab_id, :adm4_relation_vocab_id, :custom_geo_source
  def vocab_id
    object.uid
  end
  def center_latitude
    object.latitude
  end
  def center_longitude
    object.longitude
  end
  def country_iso2_code
    object.country_code
  end
  def country_vocab_id
    object.country_uid
  end
  def data_provider
    object.provider
  end
  def admin_level
    object.adm_level
  end
  def adm0_relation_vocab_id
    object.g0
  end
  def adm1_relation_vocab_id
    object.g1
  end
  def adm2_relation_vocab_id
    object.g2
  end
  def adm3_relation_vocab_id
    object.g3
  end
  def adm4_relation_vocab_id
    object.g4
  end
end
