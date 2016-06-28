class Location < ApplicationRecord

  # Ancestry
  has_ancestry

  # Search
  include LocationSearchable

  # Associations
  has_many :events
end
