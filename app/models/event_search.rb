module EventSearch
  def event_search(search_term, category=nil, location=nil, start_time=nil, end_time=nil)
    query = { query: { filtered: { filter: {} } } }
    query[:query][:filtered][:query] = ElasticsearchDsl.construct_match_query(['title', 'description'], search_term) if search_term.present?

    filters = {}
    must_filters = []
    must_filters << ElasticsearchDsl.construct_term_filter('category', category.split(',')) if category.present?
    must_filters << ElasticsearchDsl.construct_match_query(['branch', 'city'], location) if location.present?
    must_filters << construct_time_filters(start_time, end_time) if start_time.present? || end_time.present?
    filters[:must] = must_filters.flatten
    query[:query][:filtered][:filter] = ElasticsearchDsl.construct_bool(filters) if filters[:must].present?
    query.merge!({ 'from' => 0, 'size' => 1000 })
    p 'query'
    p query
    self.search(query)
  end

  def construct_time_filters(start_time, end_time)
    if start_time.present? && end_time.present?
      ElasticsearchDsl.construct_range_filter('start_time',nil,nil,start_time,(end_time++"T23:59:59")) 
    elsif start_time.present?
      ElasticsearchDsl.construct_range_filter('start_time',nil,nil,start_time,nil)
    elsif end_time.present?
      ElasticsearchDsl.construct_range_filter('start_time',nil,nil,nil,(end_time++"T23:59:59"))
    end
  end
end