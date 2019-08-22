class Contributor < ApplicationRecord
  belongs_to :package
  belongs_to :person

  delegate :name, to: :person
end
