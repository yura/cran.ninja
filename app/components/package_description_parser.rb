class PackageDescriptionParser
  def parse(file_content)
    result = {}
    long_string_for = nil

    file_content.each do |line|
      if line =~ /^Package: (.+)$/
        result[:name] = $1
      elsif line =~ /^Title: (.+)$/
        result[:title] = $1
        long_string_for = :title
      elsif line =~ /^Version: (.+)$/
        result[:version] = $1
      elsif line =~ /^Date: (.+)$/
        result[:date] = $1
      elsif line =~ /^Description: (.+)$/
        result[:description] = $1
        long_string_for = :description
      elsif line =~ /^Author: (.+)$/
        result[:author] = $1
        long_string_for = :author
      elsif line =~ /^Maintainer: (.+)$/
        result[:maintainer] = $1
        long_string_for = :maintainer
      elsif line =~ /^\s+(.+)$/ && long_string_for
        result[long_string_for] += "\n" + $1
      elsif line =~ /^(\S+?)\: .+$/
        long_string_for = nil
      end
    end

    result
  end
end
