class User < ActiveRecord::Base
  devise :database_authenticatable, :omniauthable, :token_authenticatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :access_token, :access_secret
end
