class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable,
         :validatable, :omniauthable, omniauth_providers: [:vkontakte]

  has_many :created_games, class_name: "Game", foreign_key: "creator_id"
  has_and_belongs_to_many :games, join_table: 'members_games'

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
      user.image = auth.info.image
      user.save!
    end
  end
end
