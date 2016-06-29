class User < ApplicationRecord
  rolify

  # Votes and likes
  acts_as_voter

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Associations
  has_many :user_events
  has_many :events, through: :user_events

  # Validations
  validates_presence_of :username

  # Callbacks
  after_commit :set_default_role, on: :create

  # Instance Methods
  #

  # Class Methods
  #

  # Callback Methods
  # Public: Adds a default role (user) to a user on create
  #
  # Returns nothing.
  def set_default_role
    add_role :user
  end

  def admin?
    has_role?(:admin)
  end

  def user?
    has_role?(:user)
  end

  def attending_events
    Event.scheduled.joins(:user_events).where('user_events.status = ?', 1)
  end

  def interested_events
    Event.scheduled.joins(:user_events).where('user_events.status = ?', 0)
  end
end
