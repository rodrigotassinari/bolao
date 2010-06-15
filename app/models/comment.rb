class Comment < ActiveRecord::Base

  belongs_to :commentable, :polymorphic => true, :counter_cache => true
  belongs_to :user, :counter_cache => true

  validates_presence_of :commentable_id, :commentable_type, :user_id, :body

  attr_accessible :body

  after_create :send_emails

  named_scope :ordered, :order => 'comments.created_at ASC'

  def interested_users
    interested_users_ids = Comment.all(
      :select => 'user_id',
      :conditions => [
        'commentable_type = ? AND commentable_id = ? AND user_id <> ?',
        self.commentable_type,
        self.commentable_id,
        self.user_id 
      ]
    ).map(&:user_id)
    User.find(interested_users_ids || [])
  end

  private

    # TOSPEC
    # after_create
    def send_emails
      users = self.interested_users
      users.each do |user|
        Resque.enqueue(MailJob, 'CommentsMailer', 'deliver_reply_alert', {'user_id' => user.id, 'comment_id' => self.id})
      end
      true
    end

end
