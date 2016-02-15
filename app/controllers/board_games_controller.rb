class BoardGamesController < ApplicationController

  def index
    @q = BoardGame.search(params[:q])
    @board_games = @q.result(distinct: true).includes(:categories, :mechanics).paginate(:page => params[:page])
  end

  def show
    @board_game = BoardGame.find(params[:id])
  end

end
