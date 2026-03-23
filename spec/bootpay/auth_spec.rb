# frozen_string_literal: true

RSpec.describe "PG API - Authentication", :integration do
  let(:api) do
    api = create_pg_api
    api.request_access_token
    api
  end

  it "retrieves certificate data" do
    receipt_id = '62b0a27c0f681300212e42ae'

    response = api.certificate(receipt_id)

    puts "=== Certificate Response ==="
    puts response.data.to_json

    expect(response).not_to be_nil
    expect(response.data).not_to be_nil
  end
end
