# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtBlacklist

  has_many :projects, dependent: :destroy
  has_many :tasks, through: :projects

  validates :username, presence: true, uniqueness: true, length: { in: 3..50 }
  validates :password, presence: true,
                       length: { is: 8 },
                       format: { with: /\A[a-zA-Z0-9]+\z/, message: 'must be alphanumeric' }
end
