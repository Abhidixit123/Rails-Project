# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


employee=Employee.create(
    first_name: 'Abhi',
    last_name: 'Dixit',
    email: 'abc@gmail.com',
    city:'Kanpur',
    state:'UP',
    address:'Knp Uttar Pradesh'

)

employee=Employee.new(
    first_name: 'Abhishek',
    last_name: 'Dixit',
    email: 'xwrff@gmail.com',
    city:'Kanpur',
    state:'UP',
    address:'Knp Uttar Pradesh'

)
employee=Employee.new(
    first_name: 'Aman',
    last_name: 'Dixit',
    email: 'xff@gmail.com',
    city:'Kanpur',
    state:'UP',
    address:'Knp Uttar Pradesh'

)
employee.save

employee.save

employee=Employee.new
employee.save
Employee.all