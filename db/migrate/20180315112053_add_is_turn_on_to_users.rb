class AddIsTurnOnToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :is_turn_on, :boolean, default: true
  end
end
