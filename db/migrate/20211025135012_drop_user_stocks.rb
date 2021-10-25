class DropUserStocks < ActiveRecord::Migration[6.1]
  def change
    drop_table :user_stocks
  end
end
