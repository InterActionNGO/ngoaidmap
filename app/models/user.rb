# == Schema Information
#
# Table name: users
#
#  id                                     :integer          not null, primary key
#  name                                   :string(100)      default("")
#  email                                  :string(100)
#  crypted_password                       :string(40)
#  salt                                   :string(40)
#  created_at                             :datetime
#  updated_at                             :datetime
#  remember_token                         :string(40)
#  remember_token_expires_at              :datetime
#  organization_id                        :integer
#  role                                   :string(255)
#  blocked                                :boolean          default(FALSE)
#  site_id                                :string(255)
#  description                            :text
#  password_reset_token                   :string(255)
#  password_reset_sent_at                 :datetime
#  last_login                             :datetime
#  six_months_since_last_login_alert_sent :boolean          default(FALSE)
#  login_fails                            :integer          default(0)
#

class User < ActiveRecord::Base
  belongs_to :organization
end
