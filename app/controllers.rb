Xmasbingo.controllers  do


  get "/" do
    render "/home.html.erb"
  end

  get "bingo" do
    Bingo.new(params[:name]).toss
  end

end
