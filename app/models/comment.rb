class Comment < ActiveRecord::Base

  belongs_to :commentable, :polymorphic => true, :counter_cache => true
  belongs_to :user, :counter_cache => true

  validates_presence_of :commentable_id, :commentable_type, :user_id, :body

  attr_accessible :body

  #after_create :send_emails # TODO

  named_scope :ordered, :order => 'comments.created_at ASC'

end
