class CreateBoardGameHabtmAssociations < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.integer :bgg_id
      t.string :name
      t.timestamps
    end

    create_table :board_games_categories do |t|
      t.belongs_to :board_game
      t.belongs_to :category
    end

    create_table :mechanics do |t|
      t.integer :bgg_id
      t.string :name
      t.timestamps
    end

    create_table :board_games_mechanics do |t|
      t.belongs_to :board_game
      t.belongs_to :mechanic
    end

    create_table :families do |t|
      t.integer :bgg_id
      t.string :name
      t.timestamps
    end

    create_table :board_games_families do |t|
      t.belongs_to :board_game
      t.belongs_to :family
    end

    create_table :publishers do |t|
      t.integer :bgg_id
      t.string :name
      t.timestamps
    end

    create_table :board_games_publishers do |t|
      t.belongs_to :board_game
      t.belongs_to :publisher
    end

    create_table :artists do |t|
      t.integer :bgg_id
      t.string :name
      t.timestamps
    end

    create_table :artists_board_games do |t|
      t.belongs_to :board_game
      t.belongs_to :artist
    end
  end
end
