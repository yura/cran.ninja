require 'rails_helper'

RSpec.describe CranFetcher do
  let(:cran_fetcher) { described_class.new }
  let(:cran_server) { 'http://cran.r-project.org/src/contrib/' }

  describe '#fetch' do
    subject(:fetch) { cran_fetcher.fetch(50) }

    let(:packages_file_content) { File.open('spec/fixtures/PACKAGES.sample').read }
    let(:package_description_content) { File.open('spec/fixtures/DESCRIPTION').read }

    before do
      allow(cran_fetcher).to receive(:fetch_packages_file).and_return(packages_file_content)
      allow(cran_fetcher).to receive(:fetch_package_description).with(any_args).and_return(package_description_content)
    end

    it 'fetches list of packages' do
      fetch
      expect(cran_fetcher).to have_received(:fetch_packages_file)
    end

    it 'fetches description of each file' do
      fetch
      expect(cran_fetcher).to have_received(:fetch_package_description).with(name: 'abc.data', version: '1.0')
    end

    it 'returns parsed descriptions' do
      expect(fetch).to be_an_instance_of Array
    end
  end

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

  describe '#fetch_package_description' do
    subject(:fetch_package_description) { cran_fetcher.fetch_package_description(name: 'AWR', version: '1.11.189') }

    let(:package_url) { cran_server + 'AWR_1.11.189.tar.gz' }
    let(:cran_uri) { double('cran_uri') }
    let(:package_file) { File.open('spec/fixtures/AWR_1.11.189.tar.gz') }
    let(:package_description) { File.open('spec/fixtures/AWR/DESCRIPTION').read }

    before do
      allow(cran_fetcher).to receive(:open).with(package_url).and_return(package_file)
    end

    it 'requests package file' do
      fetch_package_description
      expect(cran_fetcher).to have_received(:open).with('http://cran.r-project.org/src/contrib/AWR_1.11.189.tar.gz')
    end

    it 'reads DESCRIPTION file from the package' do
      expect(fetch_package_description).to eq(package_description)
    end
  end
end
