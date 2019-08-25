# encoding: UTF-8

require 'rubygems/package'
require 'zlib'
require 'open-uri'

class CranFetcher
  CRAN_URL = 'http://cran.r-project.org/src/contrib/'

  attr_reader :cran_server

  def self.fetch_packages_file
    open(File.join(CRAN_URL, 'PACKAGES')).read
  end

  def initialize
    @cran_server = CRAN_URL
  end

  def fetch(count = nil)
    result = []
    PackagesParser.new.parse(fetch_packages_file).each_with_index do |package, i|
      break if count && i == count

      puts package.inspect

      PackageSyncJob.perform_later package
    end

    result
  end

  def fetch_packages_file(file = File.join(cran_server, 'PACKAGES'))
    open(file).read
  end

  def fetch_package_description(name:, version:)
    tar = Gem::Package::TarReader.new(Zlib::GzipReader.new(open(File.join(cran_server, "#{name}_#{version}.tar.gz"))))
    tar.rewind
    result = tar.detect { |entry| entry.full_name == "#{name}/DESCRIPTION" }.read
    tar.close

    puts '--- raw result'
    puts result
    puts result.encoding
    puts '---'

    result
  end
end
