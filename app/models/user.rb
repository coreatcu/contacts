class User
  include Mongoid::Document
  include BCrypt

  attr_accessor :password
  before_create :confirmation_token

  field :first_name, type: String
  field :last_name, type: String
  field :email, type: String
  field :password_hash, type: String
  field :confirmed, type: Boolean
  field :confirm_token, type: String

  validates_presence_of :first_name, :last_name, :email, :password
  validates :email, :uniqueness => true
  validates :email, format: { with: /\b[A-Z0-9._%a-z\-]+@coreatcu\.com\z/,
                              message: "must be a coreatcu.com email" }
  validates :password, :length => {
    :minimum => 6,
    :maximum => 20,
    :too_short => "Passwords must be at least %{count} characters.",
    :too_long => "Passwords must be at most %{count} characters."
  }

  before_save :encrypt_password

  def self.authenticate(email, password)
    if password_correct?(email, password)
      true
    else
      false
    end
  end
  
  def self.password_correct?(user_email, password)
    user = find_by_email user_email
    return if user.nil?
    user_pass = Password.new(user.password_hash)
    user_pass == password
  end

  def email_activate
    self.confirmed = true
    self.confirm_token = nil
    save!(:validate => false)
  end

  protected
  
    def encrypt_password
      self.password_hash = Password.create(@password)
    end

  private

    def confirmation_token
      if self.confirm_token.blank?
          self.confirm_token = SecureRandom.urlsafe_base64.to_s
      end
    end
end
