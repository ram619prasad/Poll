object @event

attributes :id, :user_id, :title, :description, :location_id, :start_time, :end_time, :performers, :category, :status, :created_at, :updated_at

node :upvotes do |event|
  event.cached_votes_up
end

node :downvotes do |event|
  event.cached_votes_down
end

node :location do |event|
  event.branch
end
