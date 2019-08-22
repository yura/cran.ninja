class Contributor < ApplicationRecord
  belongs_to :package
  belongs_to :person

  def display_name
    name.present? ? name : person.name
  end
end
