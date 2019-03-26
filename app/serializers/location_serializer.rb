class LocationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :address, :city, :state, :zip_code, :longitude, :latitude
end
