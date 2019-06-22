require 'dcf'

class PackageDescriptionParser
  def parse(file_content)
    Dcf.parse(file_content).first&.slice(
      'Package', 'Title', 'Version', 'Date/Publication',
      'Description', 'Author', 'Maintainer'
    )
  end
end
