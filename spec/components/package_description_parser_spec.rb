require 'rails_helper'

RSpec.describe PackageDescriptionParser do
  let(:parser) { described_class.new }

  describe '#parse' do
    subject(:parse) { parser.parse(file_content) }

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
      expect(parse['Author']).to eq([
        { name: 'Eleanor Caves', role: 'aut, cre' },
        { name: 'Sönke Johnsen', role: 'aut' }
      ])
    end

    it 'parses maintainer' do
      expect(parse['Maintainer']).to eq([
        { name: 'Eleanor Caves', email: 'eleanor.caves@gmail.com' }
      ])
    end
  end

  describe '#parse_authors' do
    it 'returns name and role' do
      expect(parser.parse_authors('Gergely Daroczi [aut]')).to eq([
        name: 'Gergely Daroczi', role: 'aut'
      ])
    end

    it 'returns list of authors' do
      expect(parser.parse_authors('Eleanor Caves [aut, cre], Sönke Johnsen [aut]')).to eq([
        { name: 'Eleanor Caves', role: 'aut, cre' },
        { name: 'Sönke Johnsen', role: 'aut' }
      ])
    end

    it "consumes 'and' as COMMA 'Tony Plate <tplate@acm.org> and Richard Heiberger'" do
      expect(parser.parse_authors('Tony Plate <tplate@acm.org> and Richard Heiberger')).to eq([
        { name: 'Tony Plate', email: 'tplate@acm.org' },
        { name: 'Richard Heiberger' }
      ])
    end

    it "consumes comment as in 'Chia-Yi Chiu (Rutgers, the State University of New Jersey) and Wenchao Ma (The University of Alabama)'" do
      s = 'Chia-Yi Chiu (Rutgers, the State University of New Jersey) and Wenchao Ma (The University of Alabama)'
      expect(parser.parse_authors(s)).to eq([
        { name: 'Chia-Yi Chiu', comment: 'Rutgers, the State University of New Jersey' },
        { name: 'Wenchao Ma',   comment: 'The University of Alabama' }
      ])
    end

    it "parses 'and' with high priority, eg in 'Taylor B. Arnold and Ryan J. Tibshirani'" do
      s = 'Taylor B. Arnold and Ryan J. Tibshirani'
      expect(parser.parse_authors(s)).to eq([
        { name: 'Taylor B. Arnold' },
        { name: 'Ryan J. Tibshirani' }
      ])
    end

    it "does not parse 'and' inside the words" do
      s = 'andrew, band and alexander'
      expect(parser.parse_authors(s)).to eq([
        { name: 'andrew' },
        { name: 'band' },
        { name: 'alexander' }
      ])
    end
  end
end
