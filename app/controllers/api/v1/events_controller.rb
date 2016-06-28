class Api::V1::EventsController < ApplicationController

  load_and_authorize_resource
  before_action :per_page

  swagger_controller :events, 'Events Management'

  swagger_api :create do
    summary 'Creates an event'
    notes 'Api for creating an event'
    param :form, :'event[title]', :string, :required, 'Title'
    param :form, :'event[description]', :string, :required, 'Description'
    param :form, :'event[location_id]', :integer, :required, 'Location'
    param :form, :'event[start_time]', :string, :required, 'Start Date & Time'
    param :form, :'event[end_time]', :string, :optional, 'End Date & Time'
    param :form, :'event[performers]', :string, :required, 'Comma separated values of performers'
    param_list :form, :'event[category]', :string, :required, "Category", [:Quiz, :Instrument, :Dance, :Singing, :Yoga, :Seminar, :IndoorSports, :Others]
    response :ok
    response :not_found
    response :not_acceptable
    response :bad_request
    response :unauthorized
  end
  def create
    @event = Event.new(event_params)
    @event.user_id = current_user.id
    if @event.save
      render 'api/v1/events/show', status: :ok
    else
      render json: {errors: @event.errors}, status: :bad_request
    end 
  end

  swagger_api :show do
    summary 'Event Show'
    notes 'Api for showing a specific event'
    param :path, :id, :integer, :required, 'Event Id'
    response :ok
    response :not_found
    response :not_acceptable
    response :bad_request
    response :unauthorized
  end
  def show
    @event = Event.where(id: params[:id]).first
    if @event
      render 'api/v1/events/show', status: :ok
    else
      render json: {errors: "Could not find event with id #{params[:id]}"}, status: :bad_request
    end 
  end

  swagger_api :destroy do
    summary 'Event destroy'
    notes 'Api for destroying a specific event'
    param :path, :id, :integer, :required, 'Event Id'
    response :ok
    response :not_found
    response :not_acceptable
    response :bad_request
    response :unauthorized
  end
  def destroy
    @event = Event.where(id: params[:id]).first 
    @event.concluded!
    head :ok
  end

  swagger_api :update do
    summary 'updates an event'
    notes 'Api for updating an event'
    param :path, :id, :integer, :required, 'Event Id'
    param :form, :'event[title]', :string, :optional, 'Title'
    param :form, :'event[description]', :string, :optional, 'Description'
    param :form, :'event[location_id]', :integer, :optional, 'Location'
    param :form, :'event[start_time]', :string, :optional, 'Start Date & Time'
    param :form, :'event[end_time]', :string, :optional, 'End Date & Time'
    param :form, :'event[performers]', :string, :optional, 'Comma separated values of performers'
    param_list :form, :'event[category]', :string, :optional, "Category", [:Others, :Instrument, :Dance, :Singing, :Yoga, :Seminar, :IndoorSports, :Quiz]
    response :ok
    response :not_found
    response :not_acceptable
    response :bad_request
    response :unauthorized
  end
  def update
    @event = Event.where(id: params[:id]).first
    if @event.update_attributes(event_params)
      render 'api/v1/events/show', status: :ok
    else
      render json: {errors: @event.errors}, status: :bad_request
    end 
  end

  swagger_api :timeline do
    summary 'Fetches all Scheduled Events'
    notes 'API for fetching all scheduled events'
    param :query, :page, :integer, :optional, 'Page Number'
    param :query, :per_page, :integer, :optional, 'Per Page'
    response :ok
    response :not_found
    response :not_acceptable
    response :bad_request
    response :unauthorized
  end
  def timeline
    @events = Event.scheduled.page(params[:page]).per(per_page)
  end

  swagger_api :upvote do
    summary 'For voting infavour of an event'
    notes 'Api for upvoting an event'
    param :path, :id, :integer, :required, 'Event Id'
    response :ok
    response :not_found
    response :not_acceptable
    response :bad_request
    response :unauthorized
  end
  def upvote
    @event.upvote_from current_user
    head :ok
  end

  swagger_api :downvote do
    summary 'For voting against an event'
    notes 'Api for downvoting an event'
    param :path, :id, :integer, :required, 'Event Id'
    response :ok
    response :not_found
    response :not_acceptable
    response :bad_request
    response :unauthorized
  end
  def downvote
    @event.downvote_from current_user
    head :ok
  end




  private
  def event_params
    params.require(:event).permit(:title, :description, :start_time, :end_time, :performers, :category, :location_id)
  end

  def per_page
    params[:per_page] ||= Event::Pagination::DEFAULT_PER_PAGE
  end
end
