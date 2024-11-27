class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates :password, presence: true, confirmation: true, length: { minimum: 6 }, if: :password_required?
  validates :role, presence: true, inclusion: { in: %w[admin hr employee] }

  has_one :employee, dependent: :destroy  # Re-add this line
  has_many :issued_items, foreign_key: :issued_by

  after_create :employee_update

  ROLES = %w[admin hr employee].freeze

  # Role-based methods
  def admin?
    role == 'admin'
  end

  def hr?
    role == 'hr'
  end

  def employee?
    role == 'employee'
  end

  private

  # Ensures password is validated only when required
  def password_required?
    new_record? || !password.blank?
  end

  # Creates an employee record for users with the "employee" role
  def employee_update

   employee =  Employee.find_by(email: self.email)

   if employee.present?
      employee.update(user_id: self.id)
   end
  end
end
