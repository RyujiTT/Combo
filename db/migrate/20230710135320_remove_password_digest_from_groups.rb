class RemovePasswordDigestFromGroups < ActiveRecord::Migration[6.1]
  def change
    remove_column :groups, :password_digest, :string
  end
end
