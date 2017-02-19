class AddTargetsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :targets, :text
  end
end
