# join table between Users and Quotes
class Company < ApplicationRecord
  validates :name, presence: true
end
