class AddFuildsToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :created_by, :string
  end
end
