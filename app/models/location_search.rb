module LocationSearch
  def location_search(search_term)
    query = { query: { filtered: { filter: {} } } }
    query[:query][:filtered][:query] =  ElasticsearchDsl.construct_match_query(['branch', 'city'], search_term) if search_term.present?
    query.merge!({ 'from' => 0, 'size' => 100 })
    self.search(query)
  end
end