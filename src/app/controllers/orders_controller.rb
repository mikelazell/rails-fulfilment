class OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
  end

  def set_status
    @order = Order.find(params[:id])
    @order.update(current_order_status: params[:status])

    @lastStatus = @order.order_status_history.order(:dateEntered).last

    if !@lastStatus.nil?
      @lastStatus.update(dateComplete: DateTime.now())
    end

    @order.order_status_history.create(order_status: params[:status], dateEntered: DateTime.now())

    ##OrderStatusHistory.create(order_status: params[:status], order_id: params[:id], dateEntered: DateTime.now())

    redirect_back_or_to @order, notice: "Status updated to #{@order.current_order_status}"

  end
end
