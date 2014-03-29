require 'rubygems'
require 'oauth'
require 'pry'
require 'json'
require 'geocoder'

def get_coordinates(street, city)
	puts "got here2"
    puts "inside get_coordinates #{street}" 
    puts "inside get_coordinates #{city}"  

    coordinate_results = Geocoder.search("#{street}, #{city}")
    puts "the results are #{coordinate_results}"
    #=> {"lat"=>37.7883385, "lng"=>-122.3991915}
    coordinate_results_lat = coordinate_results[0].data["geometry"]["location"]["lat"]
    coordinate_results_lng = coordinate_results[0].data["geometry"]["location"]["lat"]
    puts "final coordinates are #{coordinate_results_lat}, #{coordinate_results_lng}"
    binding.pry 
end


def jcy

	consumer_key = 'YdXRvSA-a3sh0Fz8UNH0sQ'
	consumer_secret = 'KWwFyUJwTbAu6SYgT4VAIAGU9oQ'
	token = '5IUdhH-GTVblaa0BhOFrua6m-BO4M7ai'
	token_secret = '5-i0mviYcC1el-ZYM6WC6E8Gfyc'

	api_host = 'api.yelp.com'

	consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {:site => "http://#{api_host}"})
	access_token = OAuth::AccessToken.new(consumer, token, token_secret)

	#path = "/v2/search?term=restaurants&location=new%20york"
	path = "/v2/search?term=food&ll=37.483258,-122.149623"


	body = access_token.get(path).body
	h = JSON.parse(body)
	h["businesses"].each do | business |
		business_id = business["id"]
		puts business["id"]
		puts business["name"]
		puts business["image_url"]
		path = "/v2/business/roys-restaurant-san-francisco"
		body = access_token.get(path).body
		address = JSON.parse(body)
		get_coordinates(address["location"]["address"].first, address["location"]["city"])
		puts "got here"
		binding.pry
	end
	
	p body
end

jcy