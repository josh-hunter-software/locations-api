class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def serialized_json
    serializer.new(self).serialized_json
  end

  private
    def serializer
      (self.class.name + "Serializer").constantize
    end
end
