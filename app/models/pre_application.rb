class PreApplication < ApplicationRecord
  belongs_to :user
  has_many :approvals
  has_many :reports
end
