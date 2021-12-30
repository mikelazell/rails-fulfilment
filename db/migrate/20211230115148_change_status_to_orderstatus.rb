class ChangeStatusToOrderstatus < ActiveRecord::Migration[7.0]
  def change
    rename_column :order_status_history, :status, :order_status
  end
end
