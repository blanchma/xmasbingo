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
      result = CLAUS.each do |claus|
        puts claus
        if params[:name] =~ Regexp.new(claus,true)
          if target = REDIS.get(claus)
            break target
          else
            pool = (CLAUS - [claus] - [ NON_CLAUSES[claus] ])
            target = pool.sample
            REDIS.set(claus, target)
            break target
          end
        end
      end
    rescue Redis::TimeoutError
      retry
    end
    result || "not_found"
  end

end
