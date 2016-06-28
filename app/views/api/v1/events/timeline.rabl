object false

node :events do
  partial('api/v1/events/show', object: @events)
end

node :_links do
	paginate(@events)
end