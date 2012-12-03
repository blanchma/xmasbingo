Xmasbingo.controllers  do

  NON_CLAUSES = { 'Barbara' => 'Matias',
                  'Ricardo' => 'Victoria',
                  'Melina' => 'Juan',
                  'Stella' => 'Stella'}
  NON_CLAUSES = NON_CLAUSES.merge(NON_CLAUSES.invert)

   get "/" do
     render "/home.html.erb"
   end

   get "bingo" do
    puts "name: #{params[:name]}"
    begin
      result = nil
      availables = REDIS.smembers "targets"
      CLAUS.each do |claus|
        if params[:name] =~ Regexp.new(claus,true)
          if target = REDIS.get(claus)
            result = target
          else
            pool = (availables - [claus] - [ NON_CLAUSES[claus] ])
            target = pool.sample
            REDIS.set(claus, target)
            REDIS.srem "targets",target
            result = target
          end
        end
      end
    rescue Redis::TimeoutError
      retry
    end
    result || "not_found"
  end

end
