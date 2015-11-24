# == Schema Information
#
# Table name: sectors
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  oecd_dac_name         :string(255)
#  sector_vocab_code     :string(255)
#  oecd_dac_purpose_code :string(255)
#

class SectorSerializer < ActiveModel::Serializer
  cache key: "main_api_donor", expires_in: 3.hours
  attributes :type, :id, :name
  has_many :projects, serializer: ProjectWithoutSectorsSerializer
  def type
    'sectors'
  end
end
