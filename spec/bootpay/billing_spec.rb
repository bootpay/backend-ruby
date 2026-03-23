# frozen_string_literal: true

RSpec.describe "PG API - Billing", :integration do
  let(:api) do
    api = create_pg_api
    api.request_access_token
    api
  end

  it "requests a billing key" do
    response = api.get_billing_key(
      order_id:        "test_billing_#{Time.now.to_i}",
      pg:              'nicepay',
      item_name:       '테스트 정기결제',
      card_no:         '5570**********1074',  # 실제 테스트 시 마스크 제거 필요
      card_pw:         '**',
      expire_year:     '**',
      expire_month:    '**',
      identify_number: '**'
    )

    puts "=== Get Billing Key Response ==="
    puts response.data.to_json

    expect(response).not_to be_nil
    expect(response.data).not_to be_nil
  end

  it "looks up a billing key" do
    billing_key = '612deb53019943001fb52312'

    response = api.subscribe_verify(billing_key)

    puts "=== Lookup Billing Key Response ==="
    puts response.data.to_json

    expect(response).not_to be_nil
    expect(response.data).not_to be_nil
  end

  it "destroys a billing key" do
    billing_key = '612debc70d681b0039e6133d'

    response = api.destroy_billing_key(billing_key)

    puts "=== Destroy Billing Key Response ==="
    puts response.data.to_json

    expect(response).not_to be_nil
    expect(response.data).not_to be_nil
  end

  it "requests a subscribe billing payment" do
    billing_key = '612deb53019943001fb52312'

    response = api.subscribe_billing(
      billing_key: billing_key,
      item_name:   '테스트 정기결제',
      price:       1000,
      tax_free:    0,
      order_id:    "test_subscribe_#{Time.now.to_i}"
    )

    puts "=== Subscribe Billing Payment Response ==="
    puts response.data.to_json

    expect(response).not_to be_nil
    expect(response.data).not_to be_nil
  end

  it "reserves a subscribe billing and cancels it" do
    billing_key = '612deb53019943001fb52312'

    response = api.subscribe_reserve_billing(
      billing_key: billing_key,
      item_name:   '테스트 예약결제',
      price:       1000,
      tax_free:    0,
      order_id:    "test_reserve_#{Time.now.to_i}"
    )

    puts "=== Subscribe Reserve Billing Response ==="
    puts response.data.to_json

    expect(response).not_to be_nil
    expect(response.data).not_to be_nil

    # 예약 취소 시도
    if response.success? && response.data.dig(:data, :reserve_id)
      reserve_id = response.data[:data][:reserve_id]
      cancel_response = api.subscribe_reserve_cancel(reserve_id)

      puts "=== Subscribe Reserve Cancel Response ==="
      puts cancel_response.data.to_json

      expect(cancel_response).not_to be_nil
      expect(cancel_response.data).not_to be_nil
    end
  end
end
