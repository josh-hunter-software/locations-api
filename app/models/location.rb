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
      LonlatWorker.perform_async(id)
    end
end
