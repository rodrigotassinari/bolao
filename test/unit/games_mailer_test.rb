require 'test_helper'

class GamesMailerTest < ActionMailer::TestCase
  test "available_to_bet" do
    @expected.subject = 'GamesMailer#available_to_bet'
    @expected.body    = read_fixture('available_to_bet')
    @expected.date    = Time.now

    assert_equal @expected.encoded, GamesMailer.create_available_to_bet(@expected.date).encoded
  end

end
