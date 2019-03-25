class Location < ApplicationRecord
  scope :within, -> (longitude, latitude, distance_in_mile = 1) {
  where(%{
   ST_Distance(lonlat, 'POINT(%f %f)') < %d
  } % [longitude, latitude, distance_in_mile * 1609.34])
}
end
