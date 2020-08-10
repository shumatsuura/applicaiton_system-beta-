class PreApplication < ApplicationRecord
  belongs_to :user
  has_many :approvals
  accepts_nested_attributes_for :approvals
  has_many :reports
end
