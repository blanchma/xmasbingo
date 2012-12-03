puts "Initialize Claus"

CLAUS       = ['Barbara','Matias','Ricardo','Melina','Juan','Stella','Victoria']

CLAUS.each do |claus|
  REDIS.sadd "targets", claus
end

REDIS.keys.each do |key|
  REDIS.srem "targets", key if key != "targets"
end
