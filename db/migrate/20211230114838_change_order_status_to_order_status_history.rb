class ChangeOrderStatusToOrderStatusHistory < ActiveRecord::Migration[7.0]
  def change
    rename_table :order_statuses, :order_status_history
  end
end
