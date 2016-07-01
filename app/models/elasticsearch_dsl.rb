class ElasticsearchDsl
  class << self
    # Match Query
    def construct_match_query(attribute, value)
      query = if attribute.nil?
        { match_all: {} }
      elsif attribute.is_a?(Array)
        { multi_match: { query: value, fields: attribute } }
      else
        { match: { attribute => value} }
      end
    end

    # Term Filter
    def construct_term_filter(attribute, value)
      value.is_a?(Array) ? { terms: { attribute => value } } : { term: { attribute => value } }      
    end

    # Range Filter
   def construct_range_filter(attribute, gt = nil, lt = nil, gte = nil, lte = nil)
      filter = { range: { attribute => {}} }
      { gt: gt, lt: lt, gte: gte, lte: lte }.each do |key_value_array|
        filter[:range][attribute][key_value_array.first] = key_value_array.last if key_value_array.last
      end
      filter
    end

    # Bool Query
    def construct_bool(options = { must: [], must_not: [], should: [] })
      query = {}
      options.each do |key, value|
        query[key] ||= []
        query[key] << value
        query[key].flatten!
      end
      query.select!{|key, value| value.present? }
      { bool: query }
    end
  end
end