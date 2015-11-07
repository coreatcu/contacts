class Contact
  include Mongoid::Document

  field :first_name, type: String
  field :last_name, type: String
  field :company, type: String
  field :email, type: String
  field :phone_number, type: String
  field :point_people, type: String
  field :involvement, type: String
  field :open_asks, type: String

  validates_presence_of :first_name, :last_name, :company, :email,
                        :point_people, :involvement
  validates :email, :uniqueness => true
end
