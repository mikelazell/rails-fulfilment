class ChangeDateEnteredDateCompleteToTimestampInOrderStatusHistory < ActiveRecord::Migration[7.0]
  def change
    change_column :order_status_histories, :dateEntered, :timestamp
    change_column :order_status_histories, :dateComplete, :timestamp
  end
end
