class AdminMailer < ActionMailer::Base

  def test(options={})
    text = options['text']

    subject    "[#{Settings.email.subject_tag}] Email de teste - #{Time.current.to_i}"
    recipients Settings.email.admin
    from       Settings.email.from
    sent_on    Time.current
    tag        "test"
    body       :text => text
  end

  def ask_to_bet(options={})
    user = User.find(options['user_id'])

    subject    "[#{Settings.email.subject_tag}] Você ainda tem palpites à preencher"
    recipients user.email
    from       Settings.email.from
    sent_on    Time.current
    tag        "ask_to_bet"
    body       :user => user
  end

  def ask_for_payment(options={})
    user = User.find(options['user_id'])

    subject    "[#{Settings.email.subject_tag}] Você ainda não pagou sua aposta"
    recipients user.email
    from       Settings.email.from
    sent_on    Time.current
    tag        "ask_for_payment"
    body       :user => user
  end

  def ask_to_join(options={})
    name = options['name']
    email = options['email']

    subject    "Convite para participar do Bolão PiTTlândia Copa do Mundo 2010"
    recipients email
    from       Settings.email.from
    sent_on    Time.current
    tag        "ask_to_join"
    body       :name => name
  end

end
