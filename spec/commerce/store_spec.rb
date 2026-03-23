# frozen_string_literal: true

RSpec.describe "Commerce API - Store", :integration do
  let(:commerce) do
    api = create_commerce_api
    api.get_access_token
    api.as_manager
    api
  end

  it "gets store info" do
    response = commerce.store.info

    puts "=== Commerce Store Info Response ==="
    puts response.to_json

    expect(response).not_to be_nil
  end

  it "gets store detail" do
    response = commerce.store.detail

    puts "=== Commerce Store Detail Response ==="
    puts response.to_json

    expect(response).not_to be_nil
  end
end
