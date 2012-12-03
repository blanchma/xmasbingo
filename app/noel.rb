class Match < Ohm::Model
  attribute :source
  attribute :target
  index     :source
end
