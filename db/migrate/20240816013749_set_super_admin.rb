class SetSuperAdmin < ActiveRecord::Migration[7.1]
  validates :admin, inclusion: { in: [true, false] }
  def change
    add_column :users, :admin, :boolean, default: false
  end

  def up
    # Definir o usuário com id 1 como superadmin
    user = User.find_by(id: 1)
    if user
      user.update(admin: true)
    end
    
    # Desativar a flag de admin para todos os outros usuários
    User.where.not(id: 1).update_all(admin: false)
  end

  def down
    # Reverter as alterações, se necessário
    User.update_all(admin: false)
  end
end
