class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :update, :destroy]

  def show
    render json: @location.serialized_json
  end

  def create
    @location = Location.new(location_params)

    if @location.save
      render json: @location.serialized_json, status: :created, location: @location
    else
      render json: @location.errors, status: :unprocessable_entity
    end
  end

  def update
    if @location.update(location_params)
      render json: @location.serialized_json
    else
      render json: @location.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @location.destroy
  end

  private
    def set_location
      @location = Location.find(params[:id])
    end

    def location_params
      params.require(:location).permit(:address1, :address2, :city, :state, :zip_code)
    end
end
