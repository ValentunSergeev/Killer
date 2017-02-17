class JoinGamesMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :members_games do |t|
      t.belongs_to :user, index: true
      t.belongs_to :game, index: true
      t.timestamps
    end
  end
end
