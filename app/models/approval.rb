class Approval < ApplicationRecord
  belongs_to :user
  belongs_to :pre_application
end
