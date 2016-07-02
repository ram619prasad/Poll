class Api::V1::EventsController < ApplicationController

  load_and_authorize_resource except: [:attending_events, :interested_events]
  before_action :per_page, :evaluate_sort

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
    current_user.admin? ? @event.scheduled! : @event.requested!
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
    param :query, :search_term, :string, :optional, 'Search Query'
    param :query, :category, :string, :optional, 'Category'
    param :query, :location, :string, :optional, 'Location'
    param :query, :start_time, :string, :optional, 'StartTime'
    param :query, :end_time, :string, :optional, 'EndTime'
    param_list :query, :sort, :string, :optional, 'Popularity', ['Popularity']
    param :query, :user_ids, :string, :optional, 'From Users'
    param_list :query, :status, :string, :optional, 'Status', ['scheduled', 'requested', 'concluded']
    param_list :query, :voted, :string, :optional, 'Voted', ['true', 'false']
    param :query, :page, :integer, :optional, 'Page Number'
    param :query, :per_page, :integer, :optional, 'Per Page'
    response :ok
    response :not_found
    response :not_acceptable
    response :bad_request
    response :unauthorized
  end
  def timeline
    events = Event.event_search(params[:search_term], params[:category], params[:location],
      params[:start_time], params[:end_time], params[:user_ids], params[:status], params[:voted])
    @events = events.records.page(params[:page]).per(per_page).order(evaluate_sort)
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

  swagger_api :participant_response do
    summary 'Participant response'
    notes 'Api for allowing a user to show his concern for an event'
    param :path, :id, :integer, :required, 'Event Id'
    param_list :form, :response, :integer, :optional, "0 -> Interested, 1 -> Attending", [:interested, :attending]
    response :ok
    response :not_found
    response :not_acceptable
    response :bad_request
    response :unauthorized
  end
  def participant_response
    response = params[:response]
    raise Poll::Exception::InvalidParameter if (response.nil? || !([:interested, :attending].to_s.include?(response)))
    status = @event.create_participant(current_user, response)
    head :ok if status
  end

  [:attending_events, :interested_events].each do |action_name|
    swagger_api action_name do
      summary "logged in users #{action_name}"
      notes "API for fetching logged in users #{action_name}"
      param :query, :page, :integer, :optional, 'Page Number'
      param :query, :per_page, :integer, :optional, 'Per Page'
      response :ok
      response :not_found
      response :bad_request
      response :unauthorized
    end
    send :define_method, action_name do
      if action_name.eql?(:attending_events)
        @events = current_user.attending_events.page(params[:page]).per(per_page)
      elsif action_name.eql?(:interested_events)
        @events = current_user.interested_events.page(params[:page]).per(per_page)
      end
      render 'api/v1/events/timeline', status: :ok
    end
  end

  swagger_api :approve_event do
    param :path, :id, :integer, :required, 'Event Id'
    param_list :form, :status, :string, :required, "For approving or rejecting an event", ['approve', 'reject']
    response :ok
    response :not_found
    response :bad_request
    response :unauthorized
  end
  def approve_event
    raise Poll::Exception::Expired if @event.concluded?
    raise Poll::Exception::Scheduled if @event.scheduled?
    params[:status].eql?('approve') ? @event.scheduled! : ''
    head :ok
  end

  private
  def event_params
    params.require(:event).permit(:title, :description, :start_time, :end_time, :performers, :category, :location_id)
  end

  def per_page
    params[:per_page] ||= Event::Pagination::DEFAULT_PER_PAGE
  end

  def evaluate_sort
    sort = params[:sort]
    sort.nil? ? "updated_at" : sort.eql?("Date") ? "updated_at DESC" : "cached_votes_total DESC"
  end
end
