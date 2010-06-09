class Bonus < ActiveRecord::Base

  validates_presence_of :question, :points_awarded, :answer_before
  validates_uniqueness_of :question, :case_sensitive => false
  validates_numericality_of :points_awarded, :only_integer => true, :greater_than => 0

  has_many :bonus_bets, :dependent => :destroy

  after_save :score_bets!, :if => Proc.new { |bonus| bonus.answered? }

  #after_create :send_emails

  # TOSPEC
  def bet_limit_date
    self.answer_before
  end

  # TOSPEC
  def bettable?
    !answered? && Time.current < self.bet_limit_date
  end

  # TOSPEC
  def answered?
    !self.answer.blank?
  end

  def score_bets!
    bonus_bets = self.bonus_bets.all
    bonus_bets.each do |bonus_bet|
      bonus_bet.score!
    end
    true
  end

  protected

    # TOSPEC
    # after_create
    def send_emails
      users = User.all(:select => 'id')
      users.each do |user|
        #Resque.enqueue(MailJob, 'BonusMailer', 'deliver_available_to_bet', {'user_id' => user.id, 'bonus_id' => self.id}) # TODO
      end
      true
    end

end
