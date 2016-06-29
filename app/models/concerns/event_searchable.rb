module EventSearchable
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
        indexes :title, analyzer: :autocomplete, search_analyzer: :standard
        indexes :description, analyzer: :autocomplete, search_analyzer: :standard
        indexes :performers, analyzer: :autocomplete, search_analyzer: :standard
        indexes :category, analyzer: :autocomplete, search_analyzer: :standard
        indexes :status, analyzer: :autocomplete, search_analyzer: :standard
        indexes :start_time, type: 'date', format: 'strict_date_optional_time'
        indexes :end_time, type: 'date', format: 'strict_date_optional_time'
        indexes :branch, analyzer: :autocomplete, search_analyzer: :standard
        indexes :city, analyzer: :autocomplete, search_analyzer: :standard
        indexes :country, analyzer: :autocomplete, search_analyzer: :standard
      end
    end
    include Indexing
  end
  module Indexing
    def as_indexed_json(options={})
      self.as_json({
        except: [:cached_votes_up, :cached_votes_down, :cached_weighted_score, :cached_weighted_total, :cached_weighted_average],
        methods: [:branch, :city, :country]
        })
    end
  end
end
