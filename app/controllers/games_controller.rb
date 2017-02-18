class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy, :join, :start]
  before_action :authenticate_user!
  before_action :owned_game, only: [:edit, :update, :destroy, :start]

  # GET /games
  # GET /games.json
  def index
    @games = Game.all
  end

  # GET /games/1
  # GET /games/1.json
  def show
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)
    @game.creator_id = current_user.id
    current_user.games << @game

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def join
    if @game.registration?
      current_user.games << @game
      redirect_to @game, notice: "You was successfully joid to #{@game.name}."
    else
      redirect_to root_path, danger: "Registrtion's phase has finished for #{@game.name}."
    end
  end

  def start
    if @game.registration? && @game.members.size >= 2
      @game.main!
      #TODO shuffle members and set opponent for each one
      redirect_to @game, notice: "#{@game.name} was successfully started."
    else
      redirect_to root_path, notice: "#{@game.name} is already started or it has not enough players to start."
    end
  end

  private
  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:name)
  end

  def owned_game
    redirect_to root_path, notice: "#{@game.name} is not your game!" unless current_user == @game.creator
  end

  def finish_game
    @game.finished!
    #TODO set last member as winner and other finish logic
  end
end
