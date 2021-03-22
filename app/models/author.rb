class Author < ApplicationRecord
  has_and_belongs_to_many :books
  validates :first_name, presence: true
  validates :date_of_birth, presence: true
end
