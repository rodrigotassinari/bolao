class CommentsMailer < ActionMailer::Base
  
  def reply_alert(options={})
    recipient = User.find(options['user_id'])
    comment   = Comment.find(options['comment_id'], :include => [:commentable, :user])

    game = comment.commentable
    author = comment.user

    subject    "[#{Settings.email.subject_tag}] Novo comentário sobre o jogo #{game.short_description} por #{author.name}"
    recipients "#{recipient.name} <#{recipient.email}>"
    from       Settings.email.from
    sent_on    Time.current
    tag        "reply_alert"

    body       :recipient => recipient, :comment => comment, :game => game, :author => author
  end

end
