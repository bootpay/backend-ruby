module Bootpay::Billing
  extend ActiveSupport::Concern

  included do
    # 빌링키 가져오기
    # Comment by ehowlsla
    # Date: 2021-08-30
    def get_billing_key(order_id: nil, pg: nil, item_name: nil, card_no: nil, card_pw: nil, expire_year: nil, expire_month: nil, identify_number: nil,
                       user_info: {id: nil, username: nil, email: nil, phone: nil, gender: nil, area: nil, birth: nil},
                       extra: {subscribeTestPayment: nil, raw_data: nil})
      request(
        uri: 'request/card_rebill',
        payload:
          {
            order_id:        order_id,
            pg:              pg,
            item_name:       item_name,
            card_no:         card_no,
            card_pw:         card_pw,
            expire_year:     expire_year,
            expire_month:    expire_month,
            identify_number: identify_number,
            user_info:       user_info,
            extra:           extra.values.any? {|v|v != nil} ? extra : nil
          }.compact
      )
    end

    # 빌링키 삭제하기
    # Comment by ehowlsla
    # Date: 2021-08-30
    def destroy_billing_key(billing_key)
      request(
        method: :delete,
        uri: "subscribe/billing/#{billing_key}"
      )
    end

    # 빌링키로 결제 요청하기
    # Comment by ehowlsla
    # Date: 2021-08-30
    def subscribe_billing(billing_key: nil, item_name: nil, price: 0, tax_free: 0, order_id: nil, quota: nil, interest: nil,
                          user_info: {id: nil, username: nil, email: nil, phone: nil, gender: nil, area: nil, birth: nil},
                          feedback_url: nil, feedback_content_type: nil,
                          extra: {subscribeTestPayment: nil, raw_data: nil})
      raise 'billing_key 값을 입력해주세요.' if billing_key.blank?
      raise 'item_name 값을 입력해주세요.' if item_name.blank?
      raise 'price 금액을 설정을 해주세요.' if price.blank?
      raise 'order_id 주문번호를 설정해주세요.' if order_id.blank?
      request(
        uri: 'subscribe/billing',
        payload: {
          billing_key:    billing_key,
          item_name:      item_name,
          price:          price,
          tax_free:       tax_free,
          order_id:       order_id,
          quota:          quota,
          interest:       interest,
          user_info:      user_info.values.any? {|v|v != nil} ? user_info : nil,
          feedback_url:   feedback_url,
          feedback_content_type: feedback_content_type,
          extra:          extra.values.any? {|v|v != nil} ? extra : nil
        }.compact,
      )
    end

    # 빌링키로 결제 예약하기
    # Comment by ehowlsla
    # Date: 2021-08-30
    def subscribe_reserve_billing(billing_key: nil, item_name: nil, price: 0, tax_free: 0, order_id: nil, quota: 12, interest: 0,
                          user_info: {id: nil, username: nil, email: nil, phone: nil, gender: nil, area: nil, birth: nil},
                          feedback_url: nil, feedback_content_type: nil,
                          extra: {subscribeTestPayment: 0, raw_data: 0},
                          scheduler_type: nil, execute_at: nil)
      raise 'billing_key 값을 입력해주세요.' if billing_key.blank?
      raise 'item_name 값을 입력해주세요.' if item_name.blank?
      raise 'price 금액을 설정을 해주세요.' if price.blank?
      raise 'order_id 주문번호를 설정해주세요.' if order_id.blank?
      request(
        uri: 'subscribe/billing/reserve',
        payload: {
          billing_key:    billing_key,
          item_name:      item_name,
          price:          price,
          tax_free:       tax_free,
          order_id:       order_id,
          quota:          quota,
          interest:       interest,
          user_info:      user_info.values.any? {|v|v != nil} ? user_info : nil,
          feedback_url:   feedback_url,
          feedback_content_type: feedback_content_type,
          extra:          extra.values.any? {|v|v != nil} ? extra : nil,
          scheduler_type: scheduler_type.presence || 'oneshot',
          execute_at:     execute_at.presence || (Time.now + 10.seconds).to_i
        }.compact,
        )
    end

    # 결제 예약 취소하기
    # Comment by ehowlsla
    # Date: 2021-08-30
    def subscribe_reserve_cancel(reserve_id)
      raise 'reserve_id를 입력해주세요.' if reserve_id.blank?
      request(
        method: :delete,
        uri: "subscribe/billing/reserve/#{reserve_id}"
      )
    end
  end
end