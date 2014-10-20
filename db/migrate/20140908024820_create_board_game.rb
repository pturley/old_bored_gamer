class CreateBoardGame < ActiveRecord::Migration
  def change
    create_table :board_games do |t|
      t.integer :bgg_id
      t.string :primary_name
      t.text :names
      t.text :description
      t.integer :year_published
      t.integer :min_players
      t.integer :max_players
      t.decimal :playtime
      t.decimal :bgg_bayes_score
      t.decimal :bgg_user_score
      t.decimal :bgg_average_score
      t.timestamps
    end

    add_index :board_games, :bgg_id
    add_index :board_games, :bgg_bayes_score
    add_index :board_games, :bgg_user_score
    add_index :board_games, :bgg_average_score
  end
end
