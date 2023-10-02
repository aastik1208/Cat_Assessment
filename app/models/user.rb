class User < ApplicationRecord
  attr_accessor :name, :email, :phone
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :name, presence: true, length: { maximum: 255 }
  validates :phone, presence: true
end
