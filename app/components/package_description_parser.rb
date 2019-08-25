require 'dcf'

class PackageDescriptionParser
  def parse(file_content)
    result = Dcf.parse(file_content).first&.slice(
      'Package', 'Title', 'Version', 'Date/Publication',
      'Description', 'Author', 'Maintainer', 'Encoding'
    )

    #result['Author'] = parse_authors(result['Author'])
    #result['Maintainer'] = parse_authors(result['Maintainer'])
    result
  end

  def parse_authors(authors)
    authors = authors
      .gsub(' and ', ', ')
      .gsub(' with contributions by ', ', ')
      .gsub(' with contributions from ', ', ')
      .gsub(/,\s?\[/, ' [')
      .gsub(/,\s*$/, '')
      .squish.gsub(/,\s?,/, ',')

    begin
      result = Array.wrap(AuthorsParser.new.parse(authors))
    rescue Parslet::ParseFailed => e
      puts authors
      puts e.parse_failure_cause.ascii_tree
      raise
    end
    result.map { |author| author.transform_values(&:to_s).transform_values(&:squish) }
  end
end
