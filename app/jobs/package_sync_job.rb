class PackageSyncJob < ApplicationJob
  queue_as :default

  def perform(name_and_version)
    Package.sync(name_and_version)
  end
end
