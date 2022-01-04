class ChangeOrderStatusHistoryToOrderStatusHistories < ActiveRecord::Migration[7.0]
  def change
    rename_table :order_status_history, :order_status_histories
  end
end
