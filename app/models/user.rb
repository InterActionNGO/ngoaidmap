# == Schema Information
#
# Table name: users
#
#  id                        :integer         not null, primary key
#  name                      :string(100)     default("")
#  email                     :string(100)
#  crypted_password          :string(40)
#  salt                      :string(40)
#  created_at                :datetime
#  updated_at                :datetime
#  remember_token            :string(40)
#  remember_token_expires_at :datetime
#
class User < ActiveRecord::Base
  belongs_to :organization
end
