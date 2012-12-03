# Defines our constants
PADRINO_ENV  = ENV['PADRINO_ENV'] ||= ENV['RACK_ENV'] ||= 'development'  unless defined?(PADRINO_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)

# Load our dependencies
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, PADRINO_ENV)

##
# ## Enable devel logging
#
# Padrino::Logger::Config[:development][:log_level]  = :devel
# Padrino::Logger::Config[:development][:log_static] = true
#
# ## Configure your I18n
#
# I18n.default_locale = :en
#
# ## Configure your HTML5 data helpers
#
# Padrino::Helpers::TagHelpers::DATA_ATTRIBUTES.push(:dialog)
# text_field :foo, :dialog => true
# Generates: <input type="text" data-dialog="true" name="foo" />
#
# ## Add helpers to mailer
#
# Mail::Message.class_eval do
#   include Padrino::Helpers::NumberHelpers
#   include Padrino::Helpers::TranslationHelpers
# end

##
# Add your before (RE)load hooks here
#
Padrino.before_load do
  uri = URI.parse(ENV["REDISTOGO_URL"] || "redis://redistogo:257bf7163aa8479d817a3347f5d93a89@drum.redistogo.com:10032/")
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  CLAUS       = ['Barbara','Matias','Ricardo','Melina','Juan','Stella','Victoria']

  CLAUS.each do |claus|
    REDIS.sadd "targets", claus
  end

  REDIS.keys.each do |key|
    REDIS.srem "targets", REDIS.get(key) if key != "targets"
  end

end

##
# Add your after (RE)load hooks here
#
Padrino.after_load do
end

Padrino.load!
