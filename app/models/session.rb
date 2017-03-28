class Session < ApplicationRecord
  belongs_to :user
  validates :token_key, presence: true, uniqueness: true
  validates :status, presence: true, inclusion: { in: %w(active delete) }
end
