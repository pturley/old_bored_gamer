class BoardGame < ActiveRecord::Base
  def self.parse(games_xml)
    Hash.from_xml(games_xml)["items"]["item"].each do |game_hash|
      categories = game_hash["link"].select {|link| link["type"] == "boardgamecategory"}.map do |category_hash|
        Category.find_or_create_by(bgg_id: category_hash["id"], name: category_hash["value"])
      end

      mechanics = game_hash["link"].select {|link| link["type"] == "boardgamemechanic"}.map do |mechanic_hash|
        Mechanic.find_or_create_by(bgg_id: mechanic_hash["id"], name: mechanic_hash["value"])
      end

      families = game_hash["link"].select {|link| link["type"] == "boardgamefamily"}.map do |family_hash|
        Family.find_or_create_by(bgg_id: family_hash["id"], name: family_hash["value"])
      end

      publishers = game_hash["link"].select {|link| link["type"] == "boardgamepublisher"}.map do |publisher_hash|
        Publisher.find_or_create_by(bgg_id: publisher_hash["id"], name: publisher_hash["value"])
      end

      artists = game_hash["link"].select {|link| link["type"] == "boardgameartist"}.map do |artist_hash|
        Artist.find_or_create_by(bgg_id: artist_hash["id"], name: artist_hash["value"])
      end

      BoardGame.create({
        bgg_id: game_hash["id"],
        primary_name: [game_hash["name"]].flatten.select { |name| name["type"] == "primary" }.first["value"],
        image: game_hash["image"],
        names: [game_hash["name"]].flatten.map { |name| name["value"] }.join(","),
        description: game_hash["description"],
        year_published: game_hash["yearpublished"]["value"],
        min_players: game_hash["minplayers"]["value"],
        max_players: game_hash["maxplayers"]["value"],
        playtime: game_hash["playingtime"]["value"],
        bgg_bayes_score: game_hash["statistics"]["ratings"]["bayesaverage"]["value"].to_f,
        bgg_user_score: game_hash["statistics"]["ratings"]["usersrated"]["value"].to_f,
        bgg_average_score: game_hash["statistics"]["ratings"]["average"]["value"].to_f,
        categories: categories,
        mechanics: mechanics,
        families: families,
        publishers: publishers,
        artists: artists
      })
    end
  end

  has_and_belongs_to_many :categories
  has_and_belongs_to_many :mechanics
  has_and_belongs_to_many :families
  has_and_belongs_to_many :publishers
  has_and_belongs_to_many :artists

  default_scope { order(bgg_bayes_score: :desc) }

  def to_s
    self.primary_name
  end
end
