class Package < ApplicationRecord
  has_many :contributors
  has_many :people, through: :contributors

  def sync(metadata)
    self.title = metadata['Title']
    self.description = metadata['Description']
    self.published_at = metadata['Date/Publication']
    save

    metadata['Maintainer'].each do |maintainer|
      person = Person.find_or_initialize_by(email: maintainer[:email])
      person.name = maintainer[:name]
      person.save

      contributor = Contributor.find_or_initialize_by(person: person, package: self, maintainer: true)
      contributor.name = maintainer[:name]
      contributor.save
    end
  end
end

=begin
    # find person by email
    # find person by name and package

    p['Maintainer'].each do |maintainer|
      # FIXME: validate email
      if maintainer[:email].present? && maintainer[:email].include?('@')
        person = Person.find_or_create_by(email: maintainer[:email].downcase.strip)
      else
        person = Person
          .includes(:contributors)
          .where(contributors: { name: maintainer[:name], package_id: package.id, maintainer: true }).first_or_create
      end

      contributor = package.contributors.where(person: person, maintainer: true).first_or_create
      contributor.name = maintainer[:name]
      contributor.save

      if person.name.nil?
        person.name = contributor.name
      elsif person.name.length < contributor.name.length
        person.name = contributor.name
      end
      person.save
    end

    p['Author'].each do |author|
      contributor = Contributor.includes(:person)
        .where(contributors: { package: package, role: author[:role], name: author[:name] })
        .first_or_create

      contributor.comment = author[:comment]

      person = contributor.person
      if person.nil?
        if author[:email].present? && author[:email].include?('@')
          person = Person.find_or_create_by(email: author[:email])
        else
          person = Person.create_by(name: author[:name])
        end

        contributor.person = person
      end
    end
=end
