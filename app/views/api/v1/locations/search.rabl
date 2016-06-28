collection @locations

node :locations do
  partial 'api/v1/locations/show', object: @locations, root: false
end

node :_links do
  paginate(@locations)
end
