class UserEvent < ApplicationRecord
  belongs_to :user
  belongs_to :event

  enum status: [:interested, :attending]
  enum user_role: [:owner, :participant]
end
