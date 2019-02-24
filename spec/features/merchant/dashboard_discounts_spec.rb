require 'rails_helper'

RSpec.describe 'as a merchant from their dashboard' do
  before :each do
    @merchant = create(:merchant)
    @i1, @i2 = create_list(:item, 2, user: @merchant)
    @o1, @o2 = create_list(:order, 2)
    @o3 = create(:completed_order)
    @o4 = create(:cancelled_order)
    create(:order_item, order: @o1, item: @i1, quantity: 1, price: 2)
    create(:order_item, order: @o1, item: @i2, quantity: 2, price: 2)
    create(:order_item, order: @o2, item: @i2, quantity: 4, price: 2)
    create(:order_item, order: @o3, item: @i1, quantity: 4, price: 2)
    create(:order_item, order: @o4, item: @i2, quantity: 5, price: 2)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
  end

  it 'sees a link to apply discount' do
    visit dashboard_path
    save_and_open_page

    within ('.discounts') do
      expect(page).to have_link('Offer 10$ Off All Orders of 50$ or More')
    end
  end
end
