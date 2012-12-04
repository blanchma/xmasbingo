class Bingo
  PARTAKERS              = ['Barbara','Matias','Ricardo','Melina','Juan','Stella','Victoria']
  NOT_ALLOWED_MATCHS    =   (not_allowed = { 'Barbara' => 'Matias',
                                             'Ricardo' => 'Victoria',
                                             'Melina' => 'Juan',
                                             'Stella' => 'Stella'}).merge(not_allowed.invert)

  def self.init
    puts "Initialize Bingo"
    #Add all the partakers
    PARTAKERS.each do |partaker|
      REDIS.sadd "targets", partaker
    end

    #Remove partakers that were already tossed
    REDIS.keys.each do |key|
      REDIS.srem "targets", key if key != "targets"
    end
  end

  def initialize(name)
    @name = name
  end

  def toss
    begin
      @partaker = find_partaker
      if @partaker
        if target = REDIS.get(@partaker)
          result = target
        else
          pool = pool_availables
          target = pool.sample
          REDIS.set(@partaker, target)
          REDIS.srem "targets",target
          result = target
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
  def pool_availables
    availables = REDIS.smembers "targets"
    pool = availables - [@partaker] - [ NOT_ALLOWED_MATCHS[@partaker] ]
    10.times { pool.shuffle! }
    shuffle
  end

  def find_partaker
    partaker = PARTAKERS.select do |partaker|
      break partaker if @name =~ Regexp.new(partaker,true)
    end
    partaker
  end
end
