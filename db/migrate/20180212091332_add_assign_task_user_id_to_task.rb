class AddAssignTaskUserIdToTask < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :assign_task_user_id, :integer
  end
end
