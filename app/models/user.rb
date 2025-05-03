class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :incomes, dependent: :destroy
  has_many :category_incomes, dependent: :destroy
  has_many :work_times, dependent: :destroy
  has_many :category_work_times, dependent: :destroy
end
