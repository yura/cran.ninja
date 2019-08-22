require 'rails_helper'
require 'parslet/rig/rspec'

RSpec.describe AuthorsParser do
  let(:parser) { AuthorsParser.new }

  describe '#space' do
    it "consumes ' ' (space char)" do
      expect(parser.space).to parse(' ')
    end

    it "consumes '  ' (double space)" do
      expect(parser.space).to parse('  ')
    end

    it "consumes '\\t' (tab char)" do
      expect(parser.space).to parse("\t")
    end

    it "consumes '\\r'" do
      expect(parser.space).to parse("\r")
    end

    it "consumes '\\n'" do
      expect(parser.space).to parse("\n")
    end

    it "does not consume '['" do
      expect { parser.space.parse('[') }.to raise_error(Parslet::ParseFailed)
    end
  end

  describe '#lbracket' do
    it "consumes '['" do
      expect(parser.lbracket).to parse('[')
    end

    it "does not consume ' '" do
      expect { parser.lbracket.parse(' ') }.to raise_error(Parslet::ParseFailed)
    end
  end

  describe '#rbracket' do
    it "consumes ']'" do
      expect(parser.rbracket).to parse(']')
    end

    it "does not consume ' '" do
      expect { parser.rbracket.parse(' ') }.to raise_error(Parslet::ParseFailed)
    end
  end

  describe '#comma' do
    it "consumes ','" do
      expect(parser.comma).to parse(',')
    end

    it "consumes ' and '" do
      expect(parser.comma).to parse(' and')
    end

    it "does not consume ' '" do
      expect { parser.comma.parse(' ') }.to raise_error(Parslet::ParseFailed)
    end
  end

  describe '#word' do
    it "consumes just one word" do
      expect(parser.word).to parse('John')
    end

    it 'consumes words with dots' do
      expect(parser.word).to parse('W.')
    end

    it "consumes words with '" do
      expect(parser.word).to parse("O'Dea")
    end

    it "does not consume space after word" do
      expect { parser.word.parse('John ') }.to raise_error(Parslet::ParseFailed)
    end

    it "does not consume space before word" do
      expect { parser.word.parse(' John') }.to raise_error(Parslet::ParseFailed)
    end
  end

  describe '#name' do
    it "consumes just one word" do
      expect(parser.name).to parse('John')
    end

    it "consumes two words" do
      expect(parser.name).to parse('John Galt')
    end

    it 'consumes nick names' do
      expect(parser.name.parse('Jie (Kate) Hu')).to eq(name: 'Jie (Kate) Hu')
    end

    it "does not consume space before word" do
      expect { parser.name.parse(' John') }.to raise_error(Parslet::ParseFailed)
    end
  end

  describe '#role' do
    it "consumes '[aut]'" do
      expect(parser.role).to parse('[aut]')
    end

    it "consumes '[aut, con]'" do
      expect(parser.role).to parse('[aut, con]')
    end

    it "does not consume just name" do
      expect { parser.role.parse('John') }.to raise_error(Parslet::ParseFailed)
    end
  end

  describe '#author' do
    it "parses name and roles as in 'John Galt [aut, con]'" do
      expect(parser.author.parse('John Galt [aut, con]')).to eq(
        name: 'John Galt', role: 'aut, con'
      )
    end

    it 'parses name with email' do
      expect(parser.author.parse('Eleanor Caves <eleanor.caves@gmail.com>')).to eq(
        name: 'Eleanor Caves', email: 'eleanor.caves@gmail.com'
      )
    end

    it "does not consume just role" do
      expect { parser.author.parse('[aut]') }.to raise_error(Parslet::ParseFailed)
    end
  end

  describe '#authors' do
    it "consumes 'John Galt [aut]'" do
      expect(parser.authors).to parse('John Galt [aut]')
    end

    it "consumes 'John Galt [aut, con],  Fred Palm [con]'" do
      expect(parser.authors).to parse('John Galt [aut, con],  Fred Palm [con]')
    end

    it "consumes 'Eleanor Caves [aut, cre], 	Sönke Johnsen [aut]'" do
      expect(parser.authors).to parse('Eleanor Caves [aut, cre], 	Sönke Johnsen [aut]')
    end

    it "consumes 'and' as COMMA 'Tony Plate <tplate@acm.org> and Richard Heiberger'" do
      expect(parser.parse('Tony Plate <tplate@acm.org> and Richard Heiberger')).to eq([
        { name: 'Tony Plate', email: 'tplate@acm.org' },
        { name: 'Richard Heiberger' }
      ])
    end

    it "consumes urls such in 'Gilles Kratzer [aut, cre] (<https://orcid.org/0000-0002-5929-8935>), Fraser Ian Lewis [aut], Reinhard Furrer [ctb] (<https://orcid.org/0000-0002-6319-2332>), Marta Pittavino [ctb] (<https://orcid.org/0000-0002-1232-1034>)'" do
      s = 'Gilles Kratzer [aut, cre] (<https://orcid.org/0000-0002-5929-8935>), Fraser Ian Lewis [aut], Reinhard Furrer [ctb] (<https://orcid.org/0000-0002-6319-2332>), Marta Pittavino [ctb] (<https://orcid.org/0000-0002-1232-1034>)'
      expect(parser.parse(s)).to eq([
        { name: 'Gilles Kratzer',   role: 'aut, cre', url: 'https://orcid.org/0000-0002-5929-8935' },
        { name: 'Fraser Ian Lewis', role: 'aut' },
        { name: 'Reinhard Furrer',  role: 'ctb', url: 'https://orcid.org/0000-0002-6319-2332' },
        { name: 'Marta Pittavino',  role: 'ctb', url: 'https://orcid.org/0000-0002-1232-1034' }
      ])
    end

    it "consumes comment as in 'Chia-Yi Chiu (Rutgers, the State University of New Jersey) and Wenchao Ma (The University of Alabama)'" do
      s = 'Chia-Yi Chiu (Rutgers, the State University of New Jersey) and Wenchao Ma (The University of Alabama)'
      expect(parser.parse(s)).to eq([
        { name: 'Chia-Yi Chiu', comment: 'Rutgers, the State University of New Jersey' },
        { name: 'Wenchao Ma',   comment: 'The University of Alabama' }
      ])
    end

    it "consumes nick names as in 'Jie (Kate) Hu [aut, cre], Norman Breslow [aut], Gary Chan [aut]'" do
      s = 'Jie (Kate) Hu [aut, cre], Norman Breslow [aut], Gary Chan [aut]'
      expect(parser.parse(s)).to eq([
        { name: 'Jie (Kate) Hu', role: 'aut, cre' },
        { name: 'Norman Breslow', role: 'aut' },
        { name: 'Gary Chan', role: 'aut' }
      ])
    end

    it "consumes non-latin chars as in 'George Vega Yon [aut, cre], Enyelbert Muñoz [ctb]'" do
      s = 'George Vega Yon [aut, cre], Enyelbert Muñoz [ctb]'
      expect(parser.parse(s)).to eq([
        { name: 'George Vega Yon', role: 'aut, cre' },
        { name: 'Enyelbert Muñoz', role: 'ctb' }
      ])
    end

    it "consumes non-latin chars again as in 'Frédéric Schütz [aut, cre], Alix Zollinger [aut]'" do
      s = 'Frédéric Schütz [aut, cre], Alix Zollinger [aut]'
      expect(parser.parse(s)).to eq([
        { name: 'Frédéric Schütz', role: 'aut, cre' },
        { name: 'Alix Zollinger', role: 'aut' }
      ])
    end

    it "consumes '&' as in 'Antony M. Overstall, David C. Woods & Maria Adamou'" do
      s = 'Antony M. Overstall, David C. Woods & Maria Adamou'
      expect(parser.parse(s)).to eq([
        { name: 'Antony M. Overstall' },
        { name: 'David C. Woods' },
        { name: 'Maria Adamou' }
      ])
    end

    it "parses 'and' with high priority, eg in 'Taylor B. Arnold and Ryan J. Tibshirani'" do
      s = 'Taylor B. Arnold and Ryan J. Tibshirani'
      expect(parser.parse(s)).to eq([
        { name: 'Taylor B. Arnold' },
        { name: 'Ryan J. Tibshirani' }
      ])
    end

    it "does not consume just role" do
      expect { parser.authors.parse('[aut]') }.to raise_error(Parslet::ParseFailed)
    end
  end
end
