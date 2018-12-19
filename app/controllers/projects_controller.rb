class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy,:add_user,:remove_user]
  load_and_authorize_resource
  # GET /projects
  # GET /projects.json
  def index
    # @projects = Project.search(params[:search])
    if params[:search]
      @current_user_projects = Project.where("created_by_id = ? ",current_user.id )
      @projects = @current_user_projects.where('name LIKE ?', "%#{params[:search]}%")
    else
      if params[:key] == "personal"
        @projects = Project.where("created_by_id = ? ",current_user.id )
      elsif params[:key] == "shared"
        @user = current_user
        @projects = @user.projects.where("created_by_id != ? ",current_user.id )
         # @projects = @user.projects.where("created_by_id = ? ", current_user.id).where("created_by != ? " ,"client")
      elsif params[:key] == "client"
        @user = current_user
        @projects = @user.projects.where(:created_by =>"client" )
      else
        @projects = Project.where("created_by_id = ? ",current_user.id )
      end
    end    
    authorize! :read, @projects
    # @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    authorize! :read, @project
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
   authorize! :edit, @projects
  end

  # POST /projects
  # POST /projects.json
  def create
    @user = current_user
    @project = Project.new(project_params)
    @users = User.where(id: params[:project][:user_ids])
    respond_to do |format|
      if @project.save
        @user.projects << @project
        @project.update_attributes(created_by_id: current_user.id)
        @admin = User.find(@project.created_by_id)
        @users.each do |u|
          if u.id != current_user.id
            @project.users << u
            if current_user.is_turn_on == true
              ProjectMailer.add_user_in_project(u,@admin,@project).deliver_now
              
            end
          end
        end
        
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        authorize! :update, @projects
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def add_user
    @user = User.find_by_email(params[:email])
    @admin = User.find(@project.created_by_id)
    if @user.present?
      if @project.users.empty?
        @project.users << @user
      else
        @project_user_ids = @project.users.pluck(:id)
        if params[:email] != current_user.email
          if !@project_user_ids.include? @user.id
            @project.users << @user
          end
          if current_user.is_turn_on == true
            ProjectMailer.add_user_in_project(@user,@admin,@project).deliver_now
          end
          respond_to do |format|
            format.html { redirect_to @project, notice: 'project member added successfully.' }
            format.json { head :no_content }
          end
        else
          flash[:notice] = "User is already a member of this Team."
          render 'show'
        end
      end


    else
      respond_to do |format|
        format.html { redirect_to @project, notice: 'No user exist.' }
        format.json { head :no_content }
      end
    end
    
  end

  def remove_user
    @user = User.find(params[:user_id])
    @admin = User.find(@project.created_by_id)
    @project.users.delete(@user)

    if current_user.is_turn_on == true
      ProjectMailer.remove_user(@user,@admin,@project).deliver_now
    end
    respond_to do |format|
      format.html { redirect_to @project, notice: 'Removed member from project successfully.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name,:description,:created_by_id,:manager_id,:created_by,:user_ids)
    end
end