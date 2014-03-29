require 'rubygems'
require 'oauth'
require 'pry'
require 'json'
require 'geocoder'

#put the business name, coordinates, image url into a file
def get_address_coordinates(street, city)
    # puts "got in get_location_coordinates"
    # puts "inside get_coordinates #{street}"
    # puts "inside get_coordinates #{city}"

    coordinate_results = Geocoder.search("#{street}, #{city}")

    # puts "the results are #{coordinate_results}"
    coordinate_results_lat = coordinate_results[0].data["geometry"]["location"]["lat"]
    coordinate_results_lng = coordinate_results[0].data["geometry"]["location"]["lng"]
    # puts "final coordinates are #{coordinate_results_lat}, #{coordinate_results_lng}"
    return_result = "\"#{coordinate_results_lat}, #{coordinate_results_lng}\""
    #binding.pry
end


def jcy
	# Setup
	consumer_key = 'YdXRvSA-a3sh0Fz8UNH0sQ'
	consumer_secret = 'KWwFyUJwTbAu6SYgT4VAIAGU9oQ'
	token = '5IUdhH-GTVblaa0BhOFrua6m-BO4M7ai'
	token_secret = '5-i0mviYcC1el-ZYM6WC6E8Gfyc'

	api_host = 'api.yelp.com'

	consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {:site => "http://#{api_host}"})
	access_token = OAuth::AccessToken.new(consumer, token, token_secret)

	# Set the file for writing
	file = File.open("restaurants_data.txt", "w")

	# Set the location
	#path = "/v2/search?term=restaurants&location=new%20york"
	path = "/v2/search?term=food&ll=37.483258,-122.149623"

	# Get information on a list restaurants based on the location set above
	body = access_token.get(path).body
	h = JSON.parse(body)
	business_array = []
	h["businesses"].each do | business |
		business_id = business["id"]
		business_name = business["name"]
		business_image = business["image_url"]
		business_url = business["mobile_url"]

		path = "/v2/business/#{business_id}"
		body = access_token.get(path).body
		address = JSON.parse(body)
		business_coordinates = get_address_coordinates(address["location"]["address"].first, address["location"]["city"])
		#file.write("{name: #{business_name}, coordinates: #{business_coordinates}, business_url: #{business_url}, image_url: #{business_image}},")
		business_array << "{\"name\": \"#{business_name}\", \"coordinates\": #{business_coordinates}, \"business_url\": \"#{business_url}\", \"image_url\": \"#{business_image}\"}"
		# puts "name: #{business_name}, coordinates: #{business_coordinates}, image_url: #{business_image}"
		# puts "got here"
		 # binding.pry
	end
	file.write("[")
	file.write(business_array.join(","))
	file.write("]")
	file.close
	# p body
end

jcy
