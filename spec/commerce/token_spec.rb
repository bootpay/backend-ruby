# frozen_string_literal: true

RSpec.describe "Commerce API - Token", :integration do
  it "requests an access token" do
    commerce = create_commerce_api
    response = commerce.get_access_token

    puts "=== Commerce Token Response ==="
    puts response.to_json

    expect(response).not_to be_nil
    expect(response[:access_token]).not_to be_nil
  end

  it "supports method chaining with with_token" do
    commerce = create_commerce_api
    result = commerce.with_token

    puts "=== Commerce with_token ==="
    puts "has_token?: #{commerce.has_token?}"

    expect(result).to eq(commerce)
    expect(commerce.has_token?).to eq(true)
    expect(commerce.current_token).not_to be_nil
  end
end
