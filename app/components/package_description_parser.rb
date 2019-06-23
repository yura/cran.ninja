require 'dcf'

class PackageDescriptionParser
  def parse(file_content)
    result = Dcf.parse(file_content).first&.slice(
      'Package', 'Title', 'Version', 'Date/Publication',
      'Description', 'Author', 'Maintainer'
    )

    result['Author'] = parse_authors(result['Author'])
    result['Maintainer'] = parse_authors(result['Maintainer'])
    result
  end

  def parse_authors(authors)
    result = [ AuthorsParser.new.parse(authors) ].flatten
    result.map { |author| author.transform_values(&:to_s).transform_values(&:squish) }
  end
end
