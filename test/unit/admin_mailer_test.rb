require 'test_helper'

class AdminMailerTest < ActionMailer::TestCase
  test "test" do
    @expected.subject = 'AdminMailer#test'
    @expected.body    = read_fixture('test')
    @expected.date    = Time.now

    assert_equal @expected.encoded, AdminMailer.create_test(@expected.date).encoded
  end

end
