module LocationSearch
  def location_search(search_term)
    query = { query: { filtered: { filter: {} } } }
    query[:query][:filtered][:query] = { bool: { must: { match: { 'location': search_term}}}}
    self.search(query)
  end
end