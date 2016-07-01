class Api::V1::LocationsController < ApplicationController
  swagger_controller :locations, 'Location Management'

  swagger_api :search do
    summary 'Search for Location'
    notes 'API which provides search across locations'
    param :query, :location, :string, :required, 'Location Name'
    param :query, :page, :integer, :optional, 'Page Number'
    param :query, :per_page, :integer, :optional, 'Per Page'
    response :ok
    response :bad_request
    response :unauthorized
    response :not_found
  end
  def search
    @locations = Location.location_search(params[:location])
      .records
      .page(params[:page])
      .per(per_page)
  end

  private
  def per_page
    params[:per_page] ||= Event::Pagination::DEFAULT_PER_PAGE
  end
end
