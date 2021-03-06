class Order < ApplicationRecord
    STATUSES = { created: 0, picking: 1, picked: 2, awaitingShipment: 3, shipped: 4, cancelled: 5}

    has_many :order_status_history
    enum current_order_status: STATUSES
    enum source: { amazon: 0, ebay: 1, nohs: 2, etsy: 3 }

    def next_status
        STATUSES[current_order_status]
      end
end
