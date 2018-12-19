class AddCreatedByToTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :created_by, :string
  end
end
