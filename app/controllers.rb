Xmasbingo.controllers  do
  CLAUS       = ['Barbara','Matias','Ricardo','Melina','Juan','Stella','Victoria']
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
      CLAUS.each do |claus|
        if params[:name] =~ Regexp.new(claus,true)
          if target = REDIS.get(claus)
            result = target
          else
            pool = (CLAUS - [claus] - [ NON_CLAUSES[claus] ])
            target = pool.sample
            REDIS.set(claus, target)
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
