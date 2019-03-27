class LonlatWorker
  include Sidekiq::Worker

  def perform(location_id)
    location = Location.find_by(id: location_id)
    uri = URI("https://geocoding.geo.census.gov/geocoder/locations/onelineaddress?address=#{location.address1.gsub(' ', '+')},+#{location.city},+#{location.state}+#{location.zip_code}&benchmark=Public_AR_Current&format=json")
    response = JSON.parse(Net::HTTP.get(uri))["result"]
    matches = response["addressMatches"]
    if matches
      location_hash = matches.first['coordinates']
      longitude = location_hash['x']
      latitude = location_hash['y']
      coordinates = "POINT(#{longitude} #{latitude})"
      location.update_columns(lonlat: coordinates, longitude: longitude, latitude: latitude)
    end
  end
end
