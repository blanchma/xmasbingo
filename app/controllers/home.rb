Xmasbingo.controllers do

  get "/" do
    render "/home.html.erb"
  end

  get "bingo" do
    target = Bingo.new(params[:name]).toss
    puts "[Bingo] Target for #{params[:name]} is #{target}"
    target
  end

end
