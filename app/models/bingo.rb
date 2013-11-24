class Bingo
  PARTAKERS              = ['Barbara','Matias','Ricardo','Melina','Juan','Stella','Vicky']
  NOT_ALLOWED_MATCHS    =   (not_allowed = { 'Barbara' => 'Matias',
                                             'Ricardo' => 'Vicky',
                                             'Melina' => 'Juan',
                                             'Stella' => 'Stella'}).merge(not_allowed.invert)

  def self.init
    puts "Initialize Bingo"
    #Remove all partakers
    REDIS.del "targets"

    #Add all the partakers
    PARTAKERS.each do |partaker|
      REDIS.sadd "targets", partaker
    end

    #Remove partakers that were already tossed
    REDIS.keys.each do |key|
      REDIS.srem "targets", REDIS.get(key) if key != "targets"
    end
  end

  def initialize(name)
    @name = name
  end

  def toss
    begin
      @partaker = find_partaker()
      if @partaker
        if target = find_toss()
          result = target
        else
          @target = raffle()
          save_toss
          result = @target
        end
      else
        result = "not_found"
      end
    rescue Redis::TimeoutError
      retry
    end
    result
  end

  private
  def find_toss
    REDIS.get(@partaker)
  end

  def save_toss
    REDIS.set(@partaker, @target)
    REDIS.srem "targets",@target
  end

  def raffle
    rafle = nil
    availables = REDIS.smembers "targets"
    pool = availables - [@partaker] - [ NOT_ALLOWED_MATCHS[@partaker] ]
    (Random.new(Time.now.to_i).rand(5)+1).times {  pool.shuffle!  }
    (Random.new(Time.now.to_i).rand(10)+1).times {  raffle = pool.shuffle!  }
    raffle
  end

  def find_partaker
    partaker = PARTAKERS.select do |partaker|
      @name =~ Regexp.new(partaker,true)
    end
    partaker.first
  end
end
