OAUTH_CREDENTIALS={
  :my_service => {
    :key => 'c2MNL9nMvK6YCc8HxY8DanrPRcOg1S4ZC5xEbaM5',
    :secret => 'KWkmOA6tk3B5k3FysUmD9I1TZOGdC3b26eCmXHGJ'
  }
} unless defined? OAUTH_CREDENTIALS

load 'oauth/models/consumers/service_loader.rb'