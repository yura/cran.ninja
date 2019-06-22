require 'rubygems/package'
require 'zlib'
require 'open-uri'

class CranFetcher
  attr_reader :cran_server

  def initialize
    @cran_server = 'http://cran.r-project.org/src/contrib/'
  end

  def fetch(count = nil)
    packages_file_content = fetch_packages_file

    result = []
    PackagesParser.new.parse(packages_file_content).each_with_index do |package, i|
      break if count && i == count

      result << fetch_package_description(name: package['Package'], version: package['Version'])
    end

    result
  end

  def fetch_packages_file
    open(File.join(cran_server, 'PACKAGES')).read
  end

  def fetch_package_description(name:, version:)
    tar = Gem::Package::TarReader.new(Zlib::GzipReader.new(open(File.join(cran_server, "#{name}_#{version}.tar.gz"))))
    tar.rewind
    result = tar.detect { |entry| entry.full_name == "#{name}/DESCRIPTION" }.read
    tar.close

    result
  end
end
