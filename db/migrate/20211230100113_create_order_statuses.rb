class CreateOrderStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :order_statuses do |t|
      t.string :name
      t.date :dateEntered
      t.date :dateComplete
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
