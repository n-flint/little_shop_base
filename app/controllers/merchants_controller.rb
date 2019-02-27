class MerchantsController < ApplicationController
  before_action :require_merchant, only: [:show]

  def index
    if current_admin?
      @merchants = User.where(role: 1)
    else
      @merchants = User.active_merchants
    end
    @top_three_merchants_by_revenue = @merchants.top_merchants_by_revenue(3)
    @top_three_merchants_by_fulfillment = @merchants.top_merchants_by_fulfillment_time(3)
    @bottom_three_merchants_by_fulfillment = @merchants.bottom_merchants_by_fulfillment_time(3)
    @top_states_by_order_count = User.top_user_states_by_order_count(3)
    @top_cities_by_order_count = User.top_user_cities_by_order_count(3)
    @top_orders_by_items_shipped = Order.sorted_by_items_shipped(3)
  end

  def show
    @merchant = current_user
    @pending_orders = Order.pending_orders_for_merchant(current_user.id)
  end

  def existing
    merchant = User.find(params[:merchant_id])
    existing_users = User.joins(orders: {order_items: :item})
                        .select("Distinct users.*")
                        .where(items: {merchant_id: merchant.id})
    respond_to do |format|
      format.html
      format.csv {send_data existing_users.to_csv}
    end
  end

  def potential
    merchant = User.find(params[:merchant_id])
    potential_users = User.joins(orders: {order_items: :item})
                          .select("Distinct users.*")
                          .where(items: {merchant_id: merchant.id}, orders: {status: 'completed'})
                          # .where(status: "completed")
                          # require "pry"
                          # binding.pry


    users = User.all
    respond_to do |format|
      format.html
      format.csv {send_data potential_users.to_csv}
    end
  end
end
