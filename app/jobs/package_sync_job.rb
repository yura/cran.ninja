class PackageSyncJob < ApplicationJob
  queue_as :default

  def perform(name_and_version)
    package = Package.find_or_create_by(name: name_and_version[:name], version: name_and_version[:version])
    package.update(description_parsed: false)

    raw_description = CranFetcher.new.fetch_package_description(name_and_version)
    package.update(raw_description: raw_description)

    p = PackageDescriptionParser.new.parse(raw_description)

    package[:published_at] = p['Date/Publication']
    package[:title] = p['Title']
    package[:description] = p['Description']
    package.description_parsed = true
    package.save

    p['Maintainer'].each do |maintainer|
      person = Person.find_or_create_by(maintainer)
      package.contributors.where(person: person, role: 'maintainer').first_or_create
    end

    p['Author'].each do |author|
      contributor = Contributor.includes(:person)
        .where(contributors: { package_id: package.id, role: author[:role] }, people: { name: author[:name] })
        .first

      if contributor.nil?
        contributor = package.contributors.includes(:person).where(people: { name: author[:name] }).first
        if contributor.nil?
          person = Person.find_or_create_by(name: author[:name])
          package.contributors.create(person: person, role: author[:role], comment: author[:comment])
        else
          package.contributors.create(person: contributor.person, role: author[:role], comment: author[:comment])
        end
      end
    end
  end
end
