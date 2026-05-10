# frozen_string_literal: true

RSpec.describe "PG API - Token", :integration do
  it "requests an access token" do
    api = create_pg_api
    response = api.request_access_token

    puts "=== PG Token Response ==="
    puts response.data.to_json

    expect(response).not_to be_nil
    expect(response.success?).to eq(true)
    expect(response.data[:data][:token]).not_to be_nil
  end
end
