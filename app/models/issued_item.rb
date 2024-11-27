class IssuedItem < ApplicationRecord
  belongs_to :item
  belongs_to :employee
  belongs_to :admin, class_name: "User", foreign_key: 'issued_by'
  validates :issued_at,  presence: true
end
