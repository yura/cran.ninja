class CranFetcher
  attr_reader :cran_server

  def initialize
    @cran_server = 'http://cran.r-project.org/src/contrib/'
  end

  def fetch_packages_file
    open(File.join(cran_server, 'PACKAGES')).read
  end
end
