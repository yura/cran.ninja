class Package < ApplicationRecord
  PACKAGES_VALID_FIELDS = {
    "Package" => :name,
    "Version" => :version,
    "Depends" => :packages_depends,
    "Suggests" => :packages_suggests,
    "Imports" => :packages_imports,
    "LinkingTo" => :packages_linking_to,
    "Enhances" => :packages_enhances,
    "Priority" => :packages_priority,
    "License" => :packages_license,
    "License_restricts_use" => :packages_license_restricts_use,
    "License_is_FOSS" => :packages_license_is_foss,
    "NeedsCompilation" => :packages_needs_compilation,
    "OS_type" => :packages_os_type,
    "Archs" => :packages_archs,
    "MD5sum" => :packages_md5sum,
    "Path" => :packages_path
  }

  has_many :contributors
  has_many :people, through: :contributors

  def self.sync_packages
    packages_content = CranFetcher.fetch_packages_file
    packages_metadata = PackagesParser.parse(packages_content)
    packages_metadata.each do |metadata|
      package = Package.find_or_initialize_by(name: metadata['Package'], version: metadata['Version'])
      package.sync_packages_metadata(metadata)
    end
  end

  def sync_packages_metadata(metadata)
    self.packages_content = metadata

    metadata.each do |field, value|
      if PACKAGES_VALID_FIELDS.key?(field)
        assign_attributes(PACKAGES_VALID_FIELDS[field] => value)
      else
        package.packages_has_new_field = true
      end
    end

    save
  end

  def self.sync(name:, version:)
    package = Package.find_or_create_by(name: name, version: version)
    package.update(description_parsed: false)

    raw_description = CranFetcher.new.fetch_package_description(name: name, version: version)
    package.update(raw_description: raw_description)


    pdp = PackageDescriptionParser.new

    metadata = pdp.parse(raw_description)
    if metadata['Encoding'].present?
      encoded_description = raw_description.force_encoding(metadata['Encoding'])
      metadata = pdp.parse(encoded_description)
    end

    begin
      author = pdp.parse_authors(metadata['Author'])
      metadata['Author'] = author
    rescue
      metadata['Maintainer'] = [{name: author}]
      package.author_with_errors = true
    end

    begin
      maintainer = pdp.parse_authors(result['Maintainer'])
      metadata['Maintainer'] = maintainer
    rescue
      metadata['Maintainer'] = [{name: maintainer}]
      package.maintainer_with_errors = true
    end

    package.update_package(metadata)
    package.description_parsed = true
    package.save
  end

  def update_package(metadata)
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

  def license
    packages_license
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
