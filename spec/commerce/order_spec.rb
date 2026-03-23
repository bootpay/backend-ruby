# frozen_string_literal: true

RSpec.describe "Commerce API - Order", :integration do
  let(:commerce) do
    api = create_commerce_api
    api.get_access_token
    api.as_manager
    api
  end

  it "lists orders" do
    response = commerce.order.list(page: 1, limit: 10)

    puts "=== Commerce Order List Response ==="
    puts response.to_json

    expect(response).not_to be_nil
  end

  it "lists orders with filters" do
    response = commerce.order.list(
      page:   1,
      limit:  5,
      status: [1, 2, 3]
    )

    puts "=== Commerce Order List (filtered) Response ==="
    puts response.to_json

    expect(response).not_to be_nil
  end

  it "gets order detail" do
    list_response = commerce.order.list(page: 1, limit: 1)

    puts "=== Commerce Order List for Detail ==="
    puts list_response.to_json

    if list_response.is_a?(Hash) && list_response[:data].is_a?(Hash) && list_response[:data][:items].is_a?(Array)
      items = list_response[:data][:items]
      if items.length > 0
        order_id = items[0][:order_id]
        response = commerce.order.detail(order_id)

        puts "=== Commerce Order Detail Response ==="
        puts response.to_json

        expect(response).not_to be_nil
      end
    end

    expect(list_response).not_to be_nil
  end

  it "gets monthly orders" do
    # user_group_id는 실제 존재하는 값이 필요할 수 있음
    response = commerce.order.month('test_group_id', '2026-03')

    puts "=== Commerce Order Month Response ==="
    puts response.to_json

    expect(response).not_to be_nil
  end
end
