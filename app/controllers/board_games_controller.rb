class BoardGamesController < ApplicationController

  def index
    @q = BoardGame.search(params[:q])
    @board_games = @q.result(distinct: true).includes(:categories).paginate(:page => params[:page])
  end

end