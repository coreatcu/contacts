class Contact
  include Mongoid::Document
  belongs_to :user

  field :first_name, type: String
  field :last_name, type: String
  field :company, type: String
  field :role, type: String
  field :email, type: String
  field :phone_number, type: String
  field :point_person, type: String
  field :relationship_strength, type: Integer
  field :involvement, type: String
  field :open_asks, type: String
  field :core_alumni, type: Boolean
  field :columbia_alumni, type: Boolean
  field :photo_url, type: String

  validates_presence_of :first_name, :last_name, :company, :role, :email,
                        :relationship_strength, :point_person, :involvement
  validates :email, :uniqueness => true
end
