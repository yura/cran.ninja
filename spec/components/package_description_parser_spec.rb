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
    it 'returns just name if no role given' do
      expect(parser.parse_authors('Gergely Daroczi')).to eq([name: 'Gergely Daroczi'])
    end

    it 'returns just name if no role given' do
      expect(parser.parse_authors('Gergely Daroczi [aut]')).to eq([name: 'Gergely Daroczi', role: 'aut'])
    end

    it 'returns name and role' do
      expect(parser.parse_authors('Gergely Daroczi [aut]')).to eq([name: 'Gergely Daroczi', role: 'aut'])
    end

    it 'returns list of authors' do
      expect(parser.parse_authors('Eleanor Caves [aut, cre], Sönke Johnsen [aut]')).to eq([
        { name: 'Eleanor Caves', role: 'aut, cre' },
        { name: 'Sönke Johnsen', role: 'aut' }
      ])
    end

    it 'returns name and email' do
      expect(parser.parse_authors('Gergely Daroczi <daroczig@rapporter.net>')).to eq([
        name: 'Gergely Daroczi', email: 'daroczig@rapporter.net'
      ])
    end

    it 'processes "and" as "," (comma)' do
      expect(parser.parse_authors('Tony Plate <tplate@acm.org> and Richard Heiberger')).to eq([
        { name: 'Tony Plate', email: 'tplate@acm.org' },
        { name: 'Richard Heiberger' }
      ])
    end

    it 'processes author url' do
      expect(parser.parse_authors('Gilles Kratzer [aut, cre] (<https://orcid.org/0000-0002-5929-8935>), Fraser Ian Lewis [aut], Reinhard Furrer [ctb] (<https://orcid.org/0000-0002-6319-2332>), Marta Pittavino [ctb] (<https://orcid.org/0000-0002-1232-1034>)')).to eq([
        { name: 'Gilles Kratzer', role: 'aut, cre', url: 'https://orcid.org/0000-0002-5929-8935' },
        { name: 'Fraser Ian Lewis', role: 'aut' },
        { name: 'Reinhard Furrer', role: 'ctb', url: 'https://orcid.org/0000-0002-6319-2332' },
        { name: 'Marta Pittavino', role: 'ctb', url: 'https://orcid.org/0000-0002-1232-1034' }
      ])
    end

    it 'processes university' do
      expect(parser.parse_authors('Chia-Yi Chiu (Rutgers, the State University of New Jersey) and Wenchao Ma (The University of Alabama)')).to eq([
        { name: 'Chia-Yi Chiu', university: 'Rutgers, the State University of New Jersey' },
        { name: 'Wenchao Ma', university: 'The University of Alabama' }
      ])
    end

    it 'processes nick name' do
      expect(parser.parse_authors('Jie (Kate) Hu [aut, cre], Norman Breslow [aut], Gary Chan [aut]')).to eq([
        { name: 'Jie (Kate) Hu', role: 'aut, cre'},
        { name: 'Norman Breslow', role: 'aut'},
        { name: 'Gary Chan', role: 'aut' }
      ])
    end
  end
end
