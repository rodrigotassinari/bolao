require 'test_helper'

class CommentsMailerTest < ActionMailer::TestCase
  test "reply_alert" do
    @expected.subject = 'CommentsMailer#reply_alert'
    @expected.body    = read_fixture('reply_alert')
    @expected.date    = Time.now

    assert_equal @expected.encoded, CommentsMailer.create_reply_alert(@expected.date).encoded
  end

end
