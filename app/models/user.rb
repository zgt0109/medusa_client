# == Schema Information
#
# Table name: users
#
#  id                            :bigint(8)        not null, primary key
#  activation_state              :string(255)
#  activation_state_expires_at   :datetime
#  activation_token              :string(255)
#  crypted_password(密码)          :string(255)
#  email(用户名)                    :string(100)
#  name                          :string(50)
#  salt                          :string(255)
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
# Indexes
#
#  index_users_on_activation_token  (activation_token)
#  index_users_on_email             (email) UNIQUE
#

class User < ApplicationRecord
  authenticates_with_sorcery!

  attr_accessor :password, :password_confirmation
end
