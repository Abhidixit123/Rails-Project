class IssuedItem < ApplicationRecord
  belongs_to :item
  belongs_to :employee, optional: true  # Allow `nil` for deassignment
  # belongs_to :admin, class_name: "User", foreign_key: 'issued_by'

 

  # Validations
  # validates :issued_at, presence: true, unless: -> { returned_at.present? }
  # validates :returned_at, presence: true, if: -> { employee_id.nil? }
  # validates :returned_at, presence: true, if: -> { employee_id.nil? && issued_at.nil? }
  # Custom Validation (Optional)
  validate :issued_date_before_return_date, if: -> { issued_at.present? && returned_at.present? }

  private

  def issued_date_before_return_date
    if issued_at > returned_at
      errors.add(:returned_at, "must be after the issued date")
    end
  end
end
