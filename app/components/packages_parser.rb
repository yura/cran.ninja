# Parses CRAN PACKAGES file.
class PackagesParser

  # Returns list of hashes with following keys:
  #  * name - package name
  #  * version
  def parse(file_content)
    result = []
    record = {}
    file_content.split("\n").each do |line|
      if line =~ /^Package: (.+)$/
        record[:name] = $1
      elsif line =~ /^Version: (.+)$/
        record[:version] = $1
        result << record
        record = {}
      end
    end

    result
  end
end
