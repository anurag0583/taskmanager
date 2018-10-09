class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy,:add_user,:remove_user]
  load_and_authorize_resource
  # GET /teams
  # GET /teams.json
  def index
     if params[:search]
      @current_user_teams =  @teams = Team.where("created_by_id = ? ",current_user.id )
      @teams = @current_user_teams.where('name LIKE ?', "%#{params[:search]}%")
    else
      if params[:key] == "personal"
        @teams = Team.where("created_by_id = ? ",current_user.id )
      elsif params[:key] == "shared"
        @user = current_user
        @teams = @user.teams.where("created_by_id != ? ",current_user.id )
      else
        @teams = Team.where("created_by_id = ? ",current_user.id )
      end
    end
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  # POST /teams.json
  def create
    # @user = current_user
    # @team = Team.new(team_params)
    # @user.teams << @team
    @user = current_user
    @team = Team.new(team_params)
    @user.teams << @team
    @users = User.where(id: params[:team][:user_ids])
    # @users.each do |u|
    #   @team.users << u if u.id != current_user.id
    # end
    respond_to do |format|
      if @team.save
        @team.update_attributes(created_by_id: current_user.id)
        @admin = User.find(@team.created_by_id)
        @users.each do |u|
          if u.id != current_user.id
            @team.users << u if u.id != current_user.id
            if current_user.is_turn_on == true

              # HardWorker.perform_async(u,@admin,@team)
              # ProjectMailer.delay.add_user_in_project(u,@admin,@team)

              # HardWorker.perform_async('bob', 5)
              # ProjectMailer.add_user_in_project(u,@admin,@team).deliver_now
              TeamMailer.add_user(@admin,u,@team).deliver_now
              
            end
          end
        end
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def add_user
    @user = User.find_by_email(params[:email])
    if @team.users.empty?
      @team.users << @user
    else
      @team_user_ids = @team.users.pluck(:id)
      if !@team_user_ids.include? @user.id
        @team.users << @user
      end 
    end
    @admin = current_user
    if current_user.is_turn_on == true
      TeamMailer.add_user(@admin,@user,@team).deliver_now
    end

    respond_to do |format|
      format.html { redirect_to @team, notice: 'Team member added successfully.' }
      format.json { head :no_content }
    end
  end

  def remove_user
    @user = User.find(params[:user_id])
    @team.users.delete(@user)
    @admin = current_user
    
    if current_user.is_turn_on == true
      TeamMailer.remove_user(@admin,@user,@team).deliver_now
    end

    respond_to do |format|
      format.html { redirect_to @team, notice: 'Removed member from team successfully.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:name)
    end
end
