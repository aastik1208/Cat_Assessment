class User < ApplicationRecord
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :name, presence: true, length: { maximum: 50 }
  validates :phone, presence: true, format: { with: /\d[0-9]\)*\z/ }
  validates :company, presence: true, length: { maximum: 50}
end
