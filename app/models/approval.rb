class Approval < ApplicationRecord
  belongs_to :user
  belongs_to :pre_application

  validates :user_id, presence: true
end
