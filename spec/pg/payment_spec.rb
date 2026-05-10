# frozen_string_literal: true

RSpec.describe "PG API - Payment", :integration do
  let(:api) do
    api = create_pg_api
    api.request_access_token
    api
  end

  it "verifies a receipt (receipt lookup)" do
    # 실제 receipt_id가 필요하므로 존재하지 않는 ID로 API 호출 가능 여부만 확인
    receipt_id = '62b0a27c0f681300212e42ae'

    response = api.verify(receipt_id)

    puts "=== Verify Receipt Response ==="
    puts response.data.to_json

    expect(response).not_to be_nil
    # 존재하지 않는 receipt이므로 실패할 수 있지만 응답 자체는 반환되어야 함
    expect(response.data).not_to be_nil
  end

  it "confirms a payment (server submit)" do
    receipt_id = '62b0a27c0f681300212e42ae'

    response = api.confirm(receipt_id)

    puts "=== Confirm Payment Response ==="
    puts response.data.to_json

    expect(response).not_to be_nil
    expect(response.data).not_to be_nil
  end

  it "cancels a payment" do
    receipt_id = '62b0a27c0f681300212e42ae'

    response = api.cancel_payment(
      receipt_id:     receipt_id,
      cancel_price:   1000,
      cancel_tax_free: 0,
      cancel_username: '테스트',
      cancel_message:  '테스트 취소'
    )

    puts "=== Cancel Payment Response ==="
    puts response.data.to_json

    expect(response).not_to be_nil
    expect(response.data).not_to be_nil
  end

  it "requests a user token" do
    response = api.get_user_token(
      user_id:  'test_user_1234',
      email:    'test@example.com',
      name:     '홍길동',
      gender:   1,
      birth:    '901004',
      phone:    '01012341234'
    )

    puts "=== User Token Response ==="
    puts response.data.to_json

    expect(response).not_to be_nil
    expect(response.data).not_to be_nil
  end
end
