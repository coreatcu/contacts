class Contact
  include Mongoid::Document
  belongs_to :user

  field :first_name, type: String
  field :last_name, type: String
  field :company, type: String
  field :role, type: String
  field :email, type: String
  field :phone_number, type: String
  field :relationship_strength, type: Integer
  field :involvement, type: String
  field :open_asks, type: String
  field :core_alumni, type: Boolean
  field :columbia_alumni, type: Boolean
  field :photo_url, type: String

  validates_presence_of :first_name, :last_name, :company, :role, :email,
                        :relationship_strength, :involvement
  validates :email, :uniqueness => true

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      contact = find_by_id(row["id"]) || new
      contact.attributes = row.to_hash.slice(*accessible_attributes)
      contact.save!
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Csv.new(file.path, nil, :ignore)
    when ".xls" then Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}."
    end
  end
end
