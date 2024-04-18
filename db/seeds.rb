# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
users_params = [
  { email: 'user1@example.com', name: 'User One', password: 'password1' },
  { email: 'user2@example.com', name: 'User Two', password: 'password2' },
  { email: 'user3@example.com', name: 'User Three', password: 'password3' }
]

users_params.each do |params|
    User.create(params)
end

events_params = [
    { name: 'Evento Teste 1', date: '01/01/01', description: 'Descrição 1' },
    { name: 'Evento Teste 2', date: '02/02/02', description: 'Descrição 2' },
    { name: 'Evento Teste 3', date: '03/03/03', description: 'Descrição 3' },
]

events_params.each do |params|
    Event.create(params)
end