class BonusBet < ActiveRecord::Base

  attr_accessible :user_id, :user, :bonus_id, :bonus, :answer

  belongs_to :bonus, :counter_cache => true
  belongs_to :user, :counter_cache => true

  validates_presence_of :user_id, :bonus_id, :answer
  validates_uniqueness_of :user_id, :scope => :bonus_id

  before_save :cant_change_if_locked

  after_save :update_user_points_cache, :if => Proc.new { |bb| bb.user && bb.scored? }

  after_save :send_emails, :if => Proc.new { |bb| bb.user && bb.scored? }

  # TOSPEC
  def self.find_or_initialize_for(user, bonus)
    bonus_bet = BonusBet.find_by_user_id_and_bonus_id(user.id, bonus.id)
    return bonus_bet unless bonus_bet.nil?
    bonus_bet = BonusBet.new(:user => user, :bonus => bonus)
    bonus_bet
  end

  # TOSPEC
  def locked?
    !self.bonus.bettable?
  end

  # TOSPEC
  def calculate_points
    return unless self.bonus && self.bonus.answered?
    score = if self.answer == self.bonus.answer
      self.bonus.points_awarded
    else
      0
    end
    score
  end

  # TOSPEC
  def score!
    self.points = calculate_points
    return if self.points.nil?
    self.scored_at = Time.current
    save!
  end

  # TOSPEC
  def scored?
    self.points && !self.scored_at.nil?
  end

  protected

    # before_save
    # TOSPEC (+ ou -)
    def cant_change_if_locked
      if self.locked? && self.answer_changed?
        errors.add_to_base("Aposta Bônus trancada, não pode mais ser alterada.")
        false
      else
        true
      end
    end

    # after_save
    # TOSPEC
    def update_user_points_cache
      self.user.update_points_cache!
      true
    end

    # TOSPEC
    # after_save
    def send_emails
      #Resque.enqueue(MailJob, 'BonusBetsMailer', 'deliver_scored', {'user_id' => self.user_id, 'bonus_bet_id' => self.id, 'bonus_id' => self.bonus_id}) # TODO
      true
    end

end
