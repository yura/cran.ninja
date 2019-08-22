require 'rails_helper'

RSpec.describe Package, type: :model do
  let(:package) { create(:package) }

  describe '#sync' do
    subject(:sync) { package.sync(metadata) }

    let(:now) { Time.now.localtime }

    let(:metadata) do
      {
        'Title' => 'title',
        'Description' => 'description',
        'Date/Publication' => now,
        'Maintainer' => [
          { name: 'Maintainer1', email: 'user@rstudio.org', role: 'aut' }
        ]
      }
    end

    it 'sets title' do
      sync
      expect(package.title).to eq('title')
    end

    it 'sets description' do
      sync
      expect(package.description).to eq('description')
    end

    it 'sets published_at' do
      sync
      expect(package.published_at).not_to be_nil
    end

    context '[contributor]' do
      context '[new record]' do
        it 'creates maintainer contributor' do
          expect { sync }.to change(Contributor, :count).by(1)
        end

        it 'does not set contributor role' do
          sync
          contributor = Contributor.last
          expect(contributor.role).to be_nil
        end

        it 'sets contributor name' do
          sync
          contributor = Contributor.last
          expect(contributor.name).to eq('Maintainer1')
        end

        it 'set maintainer value' do
          sync
          contributor = Contributor.last
          expect(contributor.maintainer).to be_truthy
        end
      end

      context '[record already exists]' do
        let(:person) { create(:person, email: 'user@rstudio.org') }
        let!(:contributor) { create(:contributor, package: package, person: person, maintainer: true) }

        it 'does not create maintainer contributor' do
          expect { sync }.not_to change(Contributor, :count)
        end

        it 'does not set contributor role' do
          sync
          contributor = Contributor.last
          expect(contributor.role).to be_nil
        end
      end

      context '[maintainer has no email]' do
        before do
          metadata['Maintainer'].first[:email] = nil
        end

        context '[contributor]' do
          it 'creates contributor by name' do
            expect { sync }.to change(Contributor, :count).by(1)
          end

          it 'sets name' do
            sync
            contributor = Contributor.last
            expect(contributor.name).to eq('Maintainer1')
          end
        end

        context '[person]' do
          it 'sets name' do
            sync
            person = Person.last
            expect(person.name).to eq('Maintainer1')
          end

          it 'does not set email' do
            sync
            person = Person.last
            expect(person.email).to be_nil
          end
        end
      end
    end

    context '[person]' do
      context '[new record]' do
        it 'creates maintainer person' do
          expect { sync }.to change(Person, :count).by(1)
        end

        it 'sets person name' do
          sync
          person = Person.last
          expect(person.name).to eq('Maintainer1')
        end

        it 'sets person email' do
          sync
          person = Person.last
          expect(person.email).to eq('user@rstudio.org')
        end
      end

      context '[record already exists]' do
        before do
          create(:person, email: 'user@rstudio.org')
        end

        it 'does not create maintainer person' do
          expect { sync }.not_to change(Person, :count)
        end
      end
    end
  end
end
