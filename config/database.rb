uri = URI.parse(ENV["REDISTOGO_URL"] || "redis://redistogo:257bf7163aa8479d817a3347f5d93a89@drum.redistogo.com:10032/")

case Padrino.env
 when :development then REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
 # when :development then REDIS = Redis.new(:host => "localhost", :db => 1)
  when :test then REDIS = Redis.new(:host => "localhost", :db => 1)
  when :production then REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end