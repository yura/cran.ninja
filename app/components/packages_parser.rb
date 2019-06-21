# Parses CRAN PACKAGES file.
class PackagesParser

  # Returns list of hashes with following keys:
  #  * name - package name
  #  * version
  def parse(file_content)
    result = []
    package = {}
    file_content.each do |line|
      if line =~ /^Package: (.+)$/
        package[:name] = $1
      elsif line =~ /^Version: (.+)$/
        package[:version] = $1
        result << package
        package = {}
      end
    end

    result
  end
end
