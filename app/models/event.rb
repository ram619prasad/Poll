class Event < ApplicationRecord

  # Categories
  enum category: [:Others, :Instrument, :Dance, :Singing, :Yoga, :Seminar, :IndoorSports, :Quiz]
  enum status: [:scheduled, :concluded]

  # Votes and likes
  acts_as_votable

  # Associations
  has_many :user_events
  has_many :users, through: :user_events
  belongs_to :location

  # Validations
  validates :title, presence: true, length: { in: 3..30 }
  validates :description, presence: true, length: { in: 10..500 }
  validates :user_id, presence: true
  validates :performers, presence: true
  validates :category, inclusion: {in: ['Quiz', 'Instrument', 'Dance', 'Singing', 'Yoga', 'Seminar', 'IndoorSports', 'Others']}
  validates_presence_of :start_time
  validate :start_date_time

  # Callbacks
  after_commit :create_user_events, on: :create

  # Constants
  module Pagination
    DEFAULT_PER_PAGE = 10
  end

  # Scopes
  # scope :scheduled, { where(status: Event.statuses[:scheduled]) }

  # Instance Methods
  #
  def upvotes_count
    get_upvotes.count
  end

  def downvotes_count
    get_downvotes.count
  end

  # Class Methods
  #

  # Callback Methods
  #
  def create_user_events
    UserEvent.create! event: self, user_id: self.user_id
  end

  # Validation Methods
  #
  def start_date_time
    # errors.add :start_time, 'Start time cannot be empty' if start_time.nil?
    if start_time.present? && end_time.present?
       # (((Time.parse(start_time.to_s) - Time.parse(DateTime.now.to_s)).to_i)/24*3600) >= 2
      errors.add :start_time, 'must be a valid datetime' if (DateTime.parse(start_time.to_s) rescue ArgumentError) == ArgumentError
      errors.add :start_time, 'Event must be created atleast 2 days in advance' if ((((Time.parse(start_time.to_s) - Time.parse(DateTime.now.to_s)).to_i)/24*3600) < 2)
      errors.add :end_time, 'must be a valid datetime' if (DateTime.parse(end_time.to_s) rescue ArgumentError) == ArgumentError
      time_difference = ((Time.parse(end_time.to_s) - Time.parse(start_time.to_s)).to_i)/3600
      errors.add :base, 'End_time is less than start_time' if time_difference < 0
      errors.add :base, 'Duration of event cannot exceed 12 hours' if time_difference > 0 && !time_difference.between?(2,12)
    end
  end
end
