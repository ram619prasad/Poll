module LocationSearchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    extend LocationSearch
    settings index: {
      number_of_shards: 1,
      number_of_replicas: 1,
      analysis: {
        filter: {
          autocomplete_filter: {
            type: 'nGram',
            min_gram: 3,
            max_gram: 30,
            token_chars: [
              "letter",
              "digit",
              "punctuation",
              "symbol"
            ]
          }
        },
        analyzer: {
          autocomplete: {
            type: 'custom',
            tokenizer: 'standard',
            filter: ['lowercase', 'autocomplete_filter']
          }
        }
      }
    } do
      mapping do
        indexes :branch, analyzer: :autocomplete, search_analyzer: :standard
        indexes :city, analyzer: :autocomplete, search_analyzer: :standard
        indexes :country, analyzer: :autocomplete, search_analyzer: :standard
      end
    end
    include Indexing
  end
end

module Indexing
  def as_indexed_json(options={})
    self.as_json(only: [:branch, :city, :country])
  end
end