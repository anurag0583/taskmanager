class AddCreateByIdToTeam < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :created_by_id, :integer
  end
end
