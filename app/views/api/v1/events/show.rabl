object @event

attributes :id, :user_id, :title, :description, :location_id, :start_time, :end_time, :performers, :category, :created_at, :updated_at

node :upvotes do |event|
  event.upvotes_count
end

node :downvotes do |event|
  event.downvotes_count
end
