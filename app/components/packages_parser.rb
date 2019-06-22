require 'dcf'

# Parses CRAN PACKAGES file.
class PackagesParser

  # Returns list of hashes with following keys:
  #  * Package - package name
  #  * Version
  def parse(file_content)
    Dcf.parse(file_content).map do |record|
      record.slice("Package", "Version")
    end
  end
end
