# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.

# ProjectPortal::Application.config.secret_token = if Rails.env.development? or Rails.env.test?
#   ('x' * 30)
# else
#   ENV['SECRET_TOKEN']
# end

ProjectPortal::Application.config.secret_token = '321cb4335f6fe5909d87b1c5c421d9109673c377d8098c2188738a378a161de40007e2f1bd065b630f5ea5b81a4ab4cc47f5d9d3948d059670af77b94812c9f9'