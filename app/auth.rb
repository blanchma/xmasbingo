Xmasbingo.controllers :auth do

  get ':provider/callback' do
    erb "<h1>#{params[:provider]}</h1>
         <pre>#{JSON.pretty_generate(request.env['omniauth.auth'])}</pre>"
  end

  get 'failure' do
    erb "<h1>Authentication Failed:</h1><h3>message:<h3> <pre>#{params}</pre>"
  end

  get "/" do
    render "/home.html.erb"
  end

  get "bingo" do
    target = Bingo.new(params[:name]).toss
    puts "[Bingo] Target for #{params[:name]} is #{target}"
    target
  end

end
