require 'sinatra'

get '/' do
  erb :index
end

# responds with json data for the favorited movies
get '/favorites' do
  response.header['Content-Type'] = 'application/json'
  File.read('data.json')
end

# assumes data.json is a json object that is a single array.
# like, [ {}, {}, {} ]
# if query params are provided we persist the new entry
# for more ideas study https://stackoverflow.com/questions/23292530/appending-the-data-in-json-file-using-ruby/23293518#23293518
post '/favorites' do
  file = JSON.parse(File.read('data.json'))
  # matches "POST /favorites?name=foo&oid=bar"
  unless params[:name] && params[:oid]
    return 'Invalid Request'
  end
  movie = { name: params[:name], oid: params[:oid] }
  file << movie
  File.write('data.json', JSON.pretty_generate(file))
  movie.to_json
end
