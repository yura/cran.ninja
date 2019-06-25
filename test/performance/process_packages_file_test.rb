require 'test_helper'
require 'rails/performance_test_help'

class ProcessPackagesFileTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  # self.profile_options = { runs: 5, metrics: [:wall_time, :memory],
  #                          output: 'tmp/performance', formats: [:flat] }

  test "process PACKAGES using Dcf parser" do
    file_content = File.read('spec/fixtures/PACKAGES')
    PackagesParser.new.parse(file_content)
  end
end
