class Location < ApplicationRecord
  after_save :populate_lonlat if :address1_changed?
  scope :within, -> (longitude, latitude, miles = 1) {
    where(%{
     ST_Distance(lonlat, 'POINT(%f %f)') < %d
    } % [longitude, latitude, miles * 1609.34])
  }
  alias_attribute :address, :address1

  private

    def populate_lonlat
      uri = URI("https://geocoding.geo.census.gov/geocoder/locations/onelineaddress?address=#{address1.gsub(' ', '+')},+#{city},+#{state}+#{zip_code}&benchmark=Public_AR_Current&format=json")
      response = JSON.parse(Net::HTTP.get(uri))["result"]
      matches = response["addressMatches"]
      if matches
        location = matches.first['coordinates']
        coordinates = "POINT(#{location.values.join(' ')})"
        update_column(:lonlat, coordinates)
      end
    end
end
