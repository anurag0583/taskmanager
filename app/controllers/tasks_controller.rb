class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update]
  load_and_authorize_resource
  # GET /tasks
  # GET /tasks.json
  def index
    if params[:search]
      @current_user_tasks = current_user.tasks
      @tasks = @current_user_tasks.where('name LIKE ?', "%#{params[:search]}%")
      @task_count = @tasks.count
    else
      @tasks = Task.all.where(:assign_task_user_id => current_user.id).order(created_at: :desc)
      
      @task_count = @tasks.count
    end
    # @tasks = Task.all
  end
 
  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @comment = @task.comments.new
    @comments = @task.comments.all
    authorize! :read, @task
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @user = current_user
    @task = Task.new(task_params)
    @task_project = @task.project
    @user_of_task_project = @task_project.users

    if params[:task][:project_id].present?
      @project = Project.find(params[:task][:project_id])
      @project.tasks << @task
      @user.tasks << @task
    else 
      @project = Project.where(:created_by_id => current_user.id,:name=>"persnal_project")[0]
      @project.tasks << @task
      @user.tasks << @task
    end

    @user_of_task_project.each do |u|
      if u.id != current_user.id
        if current_user.is_turn_on == true
          TaskMailer.assign_task_to_user(@user,u,@task,@project).deliver_now
        end
      end
    end

    respond_to do |format|
      if @task.save
        @task.update_attributes(assign_task_user_id: current_user.id)
        @task.update_attributes(created_by_id: current_user.id)
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_status
    if params[:status].present?
      @task.status = params[:status]
    elsif params[:priority].present?
      @task.priority = params[:priority]
    end

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task status updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    # if params[:task_id]
    #   @task = Task.find(params[:task_id])
    #   @task.destroy                           
    # else
      @task = Task.find(params[:id])
      @task.destroy
    # end
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def assign_task
    @user = User.find(params[:user_id])
    @task = Task.find(params[:id])
    @task.update_attributes(assign_task_user_id: @user.id)
    # @user.tasks << @task    
    @project = @task.project    
    @admin = current_user
    # @user.tasks
    # if @user.tasks.empty?
    #   @user.tasks << @task 
    # else
    #   @user_task_ids = @user.tasks.pluck(:id)
    #   if !@user_task_ids.include? @task.id
    #     @user.tasks << @user
    #   end
    # end
    if current_user.is_turn_on == true
      TaskMailer.assign_task_to_user(@admin,@user,@task,@project).deliver_now
    end
    respond_to do |format|
      format.html { redirect_to @task, notice: 'project member added successfully.' }
      format.json { head :no_content }
    end
  end

  def dis_assign_task
    exit
    # @user = User.find(params[:user_id])
    # @project.users.delete(@user)
    # respond_to do |format|
    #   format.html { redirect_to @project, notice: 'Removed member from project successfully.' }
    #   format.json { head :no_content }
    # end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:name,:details,:status,:priority,:document,:created_by,:created_by_id,:project_id,:assign_task_user_id,:start_date, :end_date)
    end
end
