# == Schema Information
#
# Table name: media_resources
#
#  id                       :integer         not null, primary key
#  position                 :integer         default(0)
#  element_id               :integer
#  element_type             :integer
#  picture_file_name        :string(255)
#  picture_content_type     :string(255)
#  picture_filesize         :integer
#  picture_updated_at       :datetime
#  video_url                :string(255)
#  video_embed_html         :text
#  created_at               :datetime
#  updated_at               :datetime
#  caption                  :string(255)
#  video_thumb_file_name    :string(255)
#  video_thumb_content_type :string(255)
#  video_thumb_file_size    :integer
#  video_thumb_updated_at   :datetime
#

class MediaResource < ActiveRecord::Base

  has_attached_file :picture, styles: {
                                      small: {
                                        geometry: "80x46#",
                                        format: 'jpg'
                                      },
                                      medium: {
                                        geometry: "660x400#",
                                        format: 'jpg'
                                      }
                                    },
                            convert_options: {
                              all: "-quality 90"
                            },
                            url: "/system/:attachment/:id/:style.:extension"

  has_attached_file :video_thumb, styles: {
                                      medium: {
                                        geometry: "660x400#",
                                        format: 'jpg'
                                      }
                                    },
                            convert_options: {
                              all: "-quality 90"
                            },
                            url: "/system/:attachment/:id/:style.:extension"
end
