class PreApplication < ApplicationRecord
  belongs_to :user
  has_many :approvals, dependent: :destroy
  accepts_nested_attributes_for :approvals, allow_destroy: true
  has_many :reports, dependent: :destroy
  accepts_nested_attributes_for :reports, allow_destroy: true
  has_many_attached :attached_files, dependent: :destroy
  has_one :overall_approval, dependent: :destroy

  validates :genre, presence: true
  validates :item, presence: true
  validates :description, presence: true, length: { minimum: 1 }

  validates :amount, presence: true, if: :expense?

  def expense?
    genre == "財務"
  end
end
