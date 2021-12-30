class OrderStatusHistory < ApplicationRecord
  belongs_to :order
  enum order_status: { created: 0, picking: 1, picked: 2, awaitingShipment: 3, shipped: 4, cancelled: 5 }
end
