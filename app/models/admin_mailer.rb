class AdminMailer < ActionMailer::Base

  def test(text = nil)
    subject    "[#{Settings.email.subject_tag}] Email de teste - #{Time.current.to_i}"
    recipients Settings.email.admin
    from       Settings.email.from
    sent_on    Time.current
    tag        "test"

    body       :text => text
  end

end
