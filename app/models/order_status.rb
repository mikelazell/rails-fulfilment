class OrderStatus < ApplicationRecord
  belongs_to :order
  enum status: { new: 0, picking: 1, picked: 2, awaitingShipment: 3, shipped: 4, cancelled: 5 }
end
