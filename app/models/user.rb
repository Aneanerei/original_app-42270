class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         has_many :incomes, dependent: :destroy
         has_many :category_incomes, dependent: :destroy
         has_many :work_times, dependent: :destroy
         after_create :create_default_categories

def create_default_categories
  ["給料", "副業", "臨時収入"].each do |name|
    category_incomes.create(name: name)
  end
end
end
