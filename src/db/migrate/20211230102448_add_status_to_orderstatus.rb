class AddStatusToOrderstatus < ActiveRecord::Migration[7.0]
  def change
    add_column :order_statuses, :status, :integer
  end
end
