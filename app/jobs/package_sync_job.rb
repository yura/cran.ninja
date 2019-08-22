class PackageSyncJob < ApplicationJob
  queue_as :default

  def perform(name_and_version)
    package = Package.find_or_create_by(name: name_and_version[:name], version: name_and_version[:version])
    package.update(description_parsed: false)

    raw_description = CranFetcher.new.fetch_package_description(name_and_version)
    package.update(raw_description: raw_description)

    metadata = PackageDescriptionParser.new.parse(raw_description)

    package.sync(metadata)
    package.description_parsed = true
    package.save

  end
end
