class OrdersController < ApplicationController
  def new
  end

  def create
    return redirect_to action: 'pay', params: params
  end

  def pay
  end

  def success
  end
end
