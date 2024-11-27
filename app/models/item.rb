class Item < ApplicationRecord
    has_many :issued_items
    has_many :employees, through: :issued_items
    validates :name, presence: true
    validates :quantity, numericality: { greater_than_or_equal_to: 0 }
end
