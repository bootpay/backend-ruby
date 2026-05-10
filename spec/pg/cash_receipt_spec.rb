# frozen_string_literal: true

RSpec.describe "PG API - Cash Receipt", :integration do
  let(:api) do
    api = create_pg_api
    api.request_access_token
    api
  end

  # 현금영수증은 별도 모듈이 없으므로, 결제 후 연관 API로 확인
  # Ruby SDK에서는 직접적인 cash receipt 메서드가 없을 수 있음
  # 여기서는 webhook 생성으로 API 호출 가능 여부 확인

  it "creates a webhook" do
    response = api.create_webhook(
      receipt_id:  '62b0a27c0f681300212e42ae',
      webhook_url: 'https://example.com/webhook'
    )

    puts "=== Create Webhook Response ==="
    puts response.data.to_json

    expect(response).not_to be_nil
    expect(response.data).not_to be_nil
  end

  it "starts escrow delivery" do
    receipt_id    = '62b0a27c0f681300212e42ae'
    delivery_no   = '1234567890'
    delivery_corp = '로젠택배'

    response = api.delivery_start(receipt_id, delivery_no, delivery_corp)

    puts "=== Escrow Delivery Start Response ==="
    puts response.data.to_json

    expect(response).not_to be_nil
    expect(response.data).not_to be_nil
  end
end
