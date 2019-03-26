class LonlatWorker
  include Sidekiq::Worker

  def perform(location_id)
    location = Location.find_by(id: location_id)
    uri = URI("https://geocoding.geo.census.gov/geocoder/locations/onelineaddress?address=#{location.address1.gsub(' ', '+')},+#{location.city},+#{location.state}+#{location.zip_code}&benchmark=Public_AR_Current&format=json")
    response = JSON.parse(Net::HTTP.get(uri))["result"]
    matches = response["addressMatches"]
    if matches
      location_hash = matches.first['coordinates']
      coordinates = "POINT(#{location_hash.values.join(' ')})"
      location.update_column(:lonlat, coordinates)
    end
  end
end
