require 'rails_helper'

RSpec.describe PackagesParser do
  describe '#parse' do
    subject(:parse) { PackagesParser.new.parse(file_content) }
    let(:file_content) { File.open('spec/fixtures/PACKAGES.sample').read }

    it 'parses all records from the file' do
      expect(parse.size).to eq(5)
    end

    it 'parses name of the packages' do
      expect(parse.map { |p| p["Package"] }).to eq(%w{A3 abbyyR abc abc.data ABC.RAP})
    end

    it 'parses versions' do
      expect(parse.map { |p| p["Version"] }).to eq(%w{1.0.0 0.5.4 2.1 1.0 0.9.0})
    end
  end
end
