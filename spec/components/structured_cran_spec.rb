require 'rails_helper'

RSpec.describe StructuredCran do
  let(:structured_cran) { described_class.new }

  describe '.sync' do
    subject(:sync) { structured_cran.sync }

    before do
      allow_any_instance_of(CranFetcher).to receive(:fetch).and_return(
        [{"Package"=>"A3", "Title"=>"Accurate, Adaptable, and Accessible Error Metrics for Predictive Models", "Version"=>"1.0.0", "Date/Publication"=>"2015-08-16 23:05:52", "Description"=>"Supplies tools for tabulating and analyzing the results of predictive models. The methods employed are applicable to virtually any predictive model and make comparisons between different methodologies straightforward.", "Author"=>[{:name=>"Scott Fortmann-Roe"}], "Maintainer"=>[{:name=>"Scott Fortmann-Roe", :email=>"scottfr@berkeley.edu"}]}, {"Package"=>"abbyyR", "Title"=>"Access to Abbyy Optical Character Recognition (OCR) API", "Version"=>"0.5.4", "Date/Publication"=>"2018-05-30 13:20:41 UTC", "Description"=>"Get text from images of text using Abbyy Cloud Optical Character Recognition (OCR) API. Easily OCR images, barcodes, forms, documents with machine readable zones, e.g. passports. Get the results in a variety of formats including plain text and XML. To learn more about the Abbyy OCR API, see  <http://ocrsdk.com/>.", "Author"=>[{:name=>"Gaurav Sood", :role=>"aut, cre"}], "Maintainer"=>[{:name=>"Gaurav Sood", :email=>"gsood07@gmail.com"}]}, {"Package"=>"abc", "Title"=>"Tools for Approximate Bayesian Computation (ABC)", "Version"=>"2.1", "Date/Publication"=>"2015-05-05 11:34:14", "Description"=>"Implements several ABC algorithms for performing parameter estimation, model selection, and goodness-of-fit. Cross-validation tools are also available for measuring the accuracy of ABC estimates, and to calculate the misclassification probabilities of different models.", "Author"=>[{:name=>"Csillery Katalin", :role=>"aut"}, {:name=>"Lemaire Louisiane", :role=>"aut"}, {:name=>"Francois Olivier", :role=>"aut"}, {:name=>"Blum Michael", :role=>"aut, cre"}], "Maintainer"=>[{:name=>"Blum Michael", :email=>"michael.blum@imag.fr"}]}, {"Package"=>"abc.data", "Title"=>"Data Only: Tools for Approximate Bayesian Computation (ABC)", "Version"=>"1.0", "Date/Publication"=>"2015-05-05 11:34:13", "Description"=>"Contains data which are used by functions of the 'abc' package.", "Author"=>[{:name=>"Csillery Katalin", :role=>"aut"}, {:name=>"Lemaire Louisiane", :role=>"aut"}, {:name=>"Francois Olivier", :role=>"aut"}, {:name=>"Blum Michael", :role=>"aut, cre"}], "Maintainer"=>[{:name=>"Blum Michael", :email=>"michael.blum@imag.fr"}]}, {"Package"=>"ABC.RAP", "Title"=>"Array Based CpG Region Analysis Pipeline", "Version"=>"0.9.0", "Date/Publication"=>"2016-10-20 10:52:16", "Description"=>"It aims to identify candidate genes that are \xE2\x80\x9Cdifferentially methylated\xE2\x80\x9D between cases and controls. It applies Student\xE2\x80\x99s t-test and delta beta analysis to identify candidate genes containing multiple \xE2\x80\x9CCpG sites\xE2\x80\x9D.", "Author"=>[{:name=>"Abdulmonem Alsaleh", :role=>"cre, aut"}, {:name=>"Robert Weeks", :role=>"aut"}, {:name=>"Ian Morison", :role=>"aut"}, {:name=>"RStudio", :role=>"ctb"}], "Maintainer"=>[{:name=>"Abdulmonem Alsaleh", :email=>"a.alsaleh@hotmail.co.nz"}]}]
      )
    end

    it 'fetches packages from the CRAN servers' do
      expect_any_instance_of(CranFetcher).to receive(:fetch)
      sync
    end

    it 'creates packages records' do
      expect { sync }.to change(Package, :count).by(5)
    end

    it 'creates contributors records' do
      expect { sync }.to change(Contributor, :count).by(19)
    end

    it 'creates people records' do
      expect { sync }.to change(Person, :count).by(10)
    end
  end
end
