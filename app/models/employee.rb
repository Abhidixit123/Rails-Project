class Employee < ApplicationRecord
  # belongs_to :user  # Re-add this line
  has_many :documents, dependent: :destroy

  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :city, :state, :address, presence: true
  validates :dob, :doj, :job_title, presence: true

  def name
    "#{first_name} #{last_name}".strip
  end

  def name_with_email
    "#{name}(#{email})"
  end
end

