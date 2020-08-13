class PreApplication < ApplicationRecord
  belongs_to :user
  has_many :approvals, dependent: :destroy
  accepts_nested_attributes_for :approvals, allow_destroy: true
  has_many :reports, dependent: :destroy
  accepts_nested_attributes_for :reports, allow_destroy: true
  has_many_attached :attached_files, dependent: :destroy
  has_many :overall_approvals, dependent: :destroy
end
