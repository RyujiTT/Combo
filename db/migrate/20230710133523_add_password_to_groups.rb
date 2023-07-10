class AddPasswordToGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :password_digest, :string
  end
end
