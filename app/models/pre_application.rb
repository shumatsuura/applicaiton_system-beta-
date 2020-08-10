class PreApplication < ApplicationRecord
  belongs_to :user
  has_many :approvals
  accepts_nested_attributes_for :approvals, allow_destroy: true
  has_many :reports
  has_many_attached :attached_files
end
