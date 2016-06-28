class Api::V1::LocationsController < ApplicationController
  swagger_controller :locations, 'Location Management'

  swagger_api :search do
    summary 'Search for Location'
    notes 'API which provides search across locations'
    param :query, :location, :string, :required, 'Location Name'
    response :ok
    response :bad_request
    response :unauthorized
    response :not_found
  end
  def search
    @locations = Location.location_search(params[:location]).records
  end
end
