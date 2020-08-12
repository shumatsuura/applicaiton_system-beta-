class PreApplication < ApplicationRecord
  belongs_to :user
  has_many :approvals
  accepts_nested_attributes_for :approvals, allow_destroy: true
  has_many :reports
  accepts_nested_attributes_for :reports, allow_destroy: true
  has_many_attached :attached_files
  has_many :overall_approvals
end
