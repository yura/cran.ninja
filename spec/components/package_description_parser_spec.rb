require 'rails_helper'

RSpec.describe PackageDescriptionParser do
  describe '#parse' do
    subject(:parse) { described_class.new.parse(file_content) }

    let(:file_content) { File.open('spec/fixtures/DESCRIPTION') }

    it 'parses package name' do
      expect(parse[:name]).to eq('AcuityView')
    end

    it 'parses title' do
      expect(parse[:title]).to eq("A Package for Displaying Visual Scenes as They May Appear to an\nAnimal with Lower Acuity")
    end

    it 'parses version' do
      expect(parse[:version]).to eq('0.1')
    end

    it 'parses version' do
      expect(parse[:date]).to eq('2017-04-28')
    end

    it 'parses description' do
      expect(parse[:description]).to eq('This code provides a simple method for representing a visual scene as it may be seen by an animal with less acute vision. When using (or for more information), please cite the original publication.')
    end

    it 'parses authors' do
      expect(parse[:author]).to eq("Eleanor Caves [aut, cre],\nSönke Johnsen [aut]")
    end

    it 'parses maintainer' do
      expect(parse[:maintainer]).to eq('Eleanor Caves <eleanor.caves@gmail.com>')
    end
  end
end
