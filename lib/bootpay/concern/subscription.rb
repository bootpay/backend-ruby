module Bootpay::Concern::Subscription
  extend ActiveSupport::Concern

  included do
    # 빌링키 결제 데이터 가져오기
    # Comment by Gosomi
    # Date: 2021-11-01
    def lookup_subscribe_billing_key(receipt_id)
      request(
        method: :get,
        uri:    "subscribe/billing_key/#{receipt_id}"
      )
    end

    # 빌링키로 결제 요청하기
    # Comment by Gosomi
    # Date: 2021-11-02
    def request_subscribe_card_payment(billing_key:, order_name:, price:, tax_free: 0, card_quota: '00',
                                       card_interest: nil, order_id:, items: [], user: {}, extra: {})
      request(
        uri:     'subscribe/payment',
        payload: {
          billing_key:   billing_key,
          order_name:    order_name,
          price:         price,
          tax_free:      tax_free,
          card_quota:    card_quota,
          card_interest: card_interest,
          order_id:      order_id,
          items:         items,
          user:          user,
          extra:         extra
        }
      )
    end

    # 빌링키를 강제로 만료한다
    # Comment by Gosomi
    # Date: 2021-11-04
    def destroy_billing_key(billing_key)
      request(
        method: :delete,
        uri:    "subscribe/billing_key/#{billing_key}"
      )
    end

    # 빌링키를 REST
    # Comment by Gosomi
    # Date: 2021-11-04
    def request_subscribe_billing_key(pg:, order_name:, price: nil, tax_free: nil, subscription_id:, card_no:, card_pw:,
                                      card_identity_no:, card_expire_year:, card_expire_month:, extra: {}, user: {}, metadata: {})
      request(
        uri:     'request/subscribe',
        payload: {
          pg:                pg,
          order_name:        order_name,
          subscription_id:   subscription_id,
          price:             price,
          tax_free:          tax_free,
          card_no:           card_no,
          card_pw:           card_pw,
          card_identity_no:  card_identity_no,
          card_expire_year:  card_expire_year,
          card_expire_month: card_expire_month,
          extra:             extra,
          user:              user,
          metadata:          metadata
        }
      )
    end

    # 정기결제를 계속해서 진행한다
    # Comment by Gosomi
    # Date: 2022-01-18
    def request_subscribe_on_continue(receipt_id)
      request(
        method: :put,
        uri:    "request/subscribe/#{receipt_id}"
      )
    end
  end
end