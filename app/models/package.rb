class Package < ApplicationRecord
  has_many :contributors
  has_many :people, through: :contributors
end
