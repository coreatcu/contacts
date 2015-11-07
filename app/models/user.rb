class User
  include Mongoid::Document
  include BCrypt

  attr_accessor :password

  field :first_name, type: String
  field :last_name, type: String
  field :email, type: String
  field :password_hash, type: String

  validates_presence_of :first_name, :last_name, :email, :password
  validates :email, :uniqueness => true
  validates :password, :length => {
    :minimum => 6,
    :maximum => 20,
    :too_short => "Passwords must be at least %{count} characters.",
    :too_long => "Passwords mut be at most %{count} characters."
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

  protected
  
    def encrypt_password
      self.password_hash = Password.create(@password)
    end
end
