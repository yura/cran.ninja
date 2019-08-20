class PackageSyncJob < ApplicationJob
  queue_as :default

  def perform(package)
    description = CranFetcher.new.fetch_package_description(package)
    PackageDescriptionParser.new.parse(description)
  end
end
