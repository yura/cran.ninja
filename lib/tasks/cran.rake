namespace :cran do
  desc "Syncs packages"
  task sync: :environment do
    StructuredCran.new.sync
  end
end
