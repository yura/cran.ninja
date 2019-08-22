class Person < ApplicationRecord
  has_many :contributors
  has_many :packages, through: :contributors
end
