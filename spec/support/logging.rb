Spec::Runner.configure do |config|
  # Includes a description of the test being run in 'log/test.log'.
  # From: http://www.benmabey.com/2008/07/04/global-setup-in-rspec-or-how-to-add-logging-for-specs/
  config.before(:each) do
    full_example_description = "#{self.class.description} #{@method_name}"
    Rails::logger.info("\n\n#{full_example_description}\n#{'-' * (full_example_description.length)}")
  end
end