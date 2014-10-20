class Family < ActiveRecord::Base
  has_and_belongs_to_many :board_games
end
