class Game < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_and_belongs_to_many :members, join_table: 'members_games',
    class_name: 'User'
  enum phase: [:registration, :main, :finished] 
end
