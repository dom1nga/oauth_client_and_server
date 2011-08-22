require 'oauth/models/consumers/token'
class ConsumerToken < ActiveRecord::Base
  include Oauth::Models::Consumers::Token

  # You can safely remove this callback if you don't allow login from any of your services
  before_create :create_user
  belongs_to :user
end