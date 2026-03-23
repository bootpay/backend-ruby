# frozen_string_literal: true

RSpec.describe "Commerce API - Product", :integration do
  let(:commerce) do
    api = create_commerce_api
    api.get_access_token
    api.as_manager
    api
  end

  it "lists products" do
    response = commerce.product.list(page: 1, limit: 10)

    puts "=== Commerce Product List Response ==="
    puts response.to_json

    expect(response).not_to be_nil
  end

  it "creates a product" do
    product_data = {
      name:  "테스트 상품 #{Time.now.to_i}",
      price: 10000,
      type:  0
    }

    response = commerce.product.create(product_data)

    puts "=== Commerce Product Create Response ==="
    puts response.to_json

    expect(response).not_to be_nil
  end

  it "gets product detail" do
    # 먼저 목록에서 product_id를 가져온 후 상세 조회
    list_response = commerce.product.list(page: 1, limit: 1)

    puts "=== Commerce Product List for Detail ==="
    puts list_response.to_json

    if list_response.is_a?(Hash) && list_response[:data].is_a?(Hash) && list_response[:data][:items].is_a?(Array)
      items = list_response[:data][:items]
      if items.length > 0
        product_id = items[0][:product_id]
        response = commerce.product.detail(product_id)

        puts "=== Commerce Product Detail Response ==="
        puts response.to_json

        expect(response).not_to be_nil
      end
    end

    expect(list_response).not_to be_nil
  end

  it "updates a product" do
    list_response = commerce.product.list(page: 1, limit: 1)

    if list_response.is_a?(Hash) && list_response[:data].is_a?(Hash) && list_response[:data][:items].is_a?(Array)
      items = list_response[:data][:items]
      if items.length > 0
        product_id = items[0][:product_id]
        response = commerce.product.update({
          product_id: product_id,
          name:       "수정된 상품 #{Time.now.to_i}"
        })

        puts "=== Commerce Product Update Response ==="
        puts response.to_json

        expect(response).not_to be_nil
      end
    end
  end

  it "changes product status" do
    list_response = commerce.product.list(page: 1, limit: 1)

    if list_response.is_a?(Hash) && list_response[:data].is_a?(Hash) && list_response[:data][:items].is_a?(Array)
      items = list_response[:data][:items]
      if items.length > 0
        product_id = items[0][:product_id]
        response = commerce.product.status({
          product_id: product_id,
          status:     1
        })

        puts "=== Commerce Product Status Response ==="
        puts response.to_json

        expect(response).not_to be_nil
      end
    end
  end
end
