class AddCreateByIdToTask < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :created_by_id, :integer
  end
end
