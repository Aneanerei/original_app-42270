class Income < ApplicationRecord
  belongs_to :user
  belongs_to :category_income

  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :date, presence: true

  
end
