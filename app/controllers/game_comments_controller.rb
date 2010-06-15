class GameCommentsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_game

  def create
    @comment = @game.comments.build(params[:comment])
    @comment.user = current_user
    if @comment.save
      flash[:success] = "Comentário criado com sucesso."
      redirect_to game_path(@game, :anchor => "comment_#{@comment.id}")
    else
      flash[:error] = "Erro: você não preencheu o comentário!"
      redirect_to game_path(@game)
    end
  end

  def destroy
    # TODO
  end

  private

    def find_game
      @game = Game.find(params[:game_id])
    end

end
