class OrdersController < ApplicationController

  #-------------#

  def index
    @orders = Order.all
  end

  #-------------#

  def detail

    @order = Order.find(params[:id])

  end

  #-------------#

  def new

    @order = Order.new

  end

  #-------------#

  def create
    
    @order = Order.new(order_params)
    @saved = @order.save

    if @order.save

      @orderStatus = @order.order_status_history.create(order_status: 'created', dateEntered: DateTime.now())
      @order.current_order_status = @orderstatus;
      @order.save

      redirect_to '/orders'
    else
      render :new, status: :unprocessable_entity
    end
  end

  #-------------#

  def set_status
    @order = Order.find(params[:id])
    @order.update(current_order_status: params[:status])

    @lastStatus = @order.order_status_history.order(:dateEntered).last

    if !@lastStatus.nil?
      @lastStatus.update(dateComplete: DateTime.now())
    end

    @order.order_status_history.create(order_status: params[:status], dateEntered: DateTime.now())

    redirect_back_or_to @order, notice: "Status updated to #{@order.current_order_status}"

  end

  #-------------#

  private
    def order_params
      params.require(:order).permit(:name, :date, :source, :total)
    end

end
