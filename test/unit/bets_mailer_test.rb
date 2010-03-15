require 'test_helper'

class BetsMailerTest < ActionMailer::TestCase
  test "scored" do
    @expected.subject = 'BetsMailer#scored'
    @expected.body    = read_fixture('scored')
    @expected.date    = Time.now

    #assert_equal @expected.encoded, BetsMailer.create_scored(@expected.date).encoded # TODO
  end

end
