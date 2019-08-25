require 'dcf'

# Parses CRAN PACKAGES file.
class PackagesParser
  # Returns list of hashes
  def self.parse(file_content)
    Dcf.parse(file_content)
  end
end
