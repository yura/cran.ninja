require 'rails_helper'

RSpec.describe PackageDescriptionParser do
  describe '#parse' do
    subject(:parse) { described_class.new.parse(file_content) }

    let(:file_content) { File.open('spec/fixtures/DESCRIPTION').read }

    it 'parses package name' do
      expect(parse['Package']).to eq('AcuityView')
    end

    it 'parses title' do
      expect(parse['Title']).to eq("A Package for Displaying Visual Scenes as They May Appear to an Animal with Lower Acuity")
    end

    it 'parses version' do
      expect(parse['Version']).to eq('0.1')
    end

    it 'parses version' do
      expect(parse['Date/Publication']).to eq('2017-05-09 07:10:48 UTC')
    end

    it 'parses description' do
      expect(parse['Description']).to eq('This code provides a simple method for representing a visual scene as it may be seen by an animal with less acute vision. When using (or for more information), please cite the original publication.')
    end

    it 'parses authors' do
      expect(parse['Author']).to eq("Eleanor Caves [aut, cre], \tSönke Johnsen [aut]")
    end

    it 'parses maintainer' do
      expect(parse['Maintainer']).to eq('Eleanor Caves <eleanor.caves@gmail.com>')
    end
  end
end
