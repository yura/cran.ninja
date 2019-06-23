class StructuredCran
  def sync
    packages = CranFetcher.new.fetch
    packages.each do |p|
      package = Package.find_or_initialize_by(name: p['Package'], version: p['Version'])
      package[:published_at] = p['Date/Publication']
      package[:title] = p['Title']
      package[:description] = p['Description']
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
            package.contributors.create(person: person, role: author[:role])
          else
            package.contributors.create(person: contributor.person, role: author[:role])
          end
        end
      end
    end
  end
end
