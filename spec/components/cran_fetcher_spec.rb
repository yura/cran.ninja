require 'rails_helper'

RSpec.describe CranFetcher do
  let(:cran_fetcher) { described_class.new }
  let(:cran_server) { 'http://cran.r-project.org/src/contrib/' }

  describe '#fetch_packages_file' do
    subject(:fetch_packages_file) { cran_fetcher.fetch_packages_file }

    let(:packages_url) { cran_server + 'PACKAGES' }
    let(:cran_uri) { double('cran_uri') }

    before do
      allow(cran_fetcher).to receive(:open).with(packages_url).and_return(cran_uri)
      allow(cran_uri).to receive(:read)
    end

    it 'requests PACKAGES file from the server' do
      fetch_packages_file
      expect(cran_fetcher).to have_received(:open).with(packages_url)
    end

    it 'reads the file' do
      fetch_packages_file
      expect(cran_uri).to have_received(:read)
    end
  end
end
