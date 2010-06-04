class BetsMailer < ActionMailer::Base

  def scored(recipient, bet, game)
    subject    "[#{Settings.email.subject_tag}] Você marcou pontos no bolão!"
    recipients "#{recipient.name} <#{recipient.email}>"
    from       Settings.email.from
    sent_on    Time.current
    tag        "scored"
    
    body       :recipient => recipient, :bet => bet, :game => game
  end

end
