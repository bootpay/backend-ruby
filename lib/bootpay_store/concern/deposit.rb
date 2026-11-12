module BootpayStore::Concern::Deposit
  extend ActiveSupport::Concern

  # 뱅크알람 입금대기 웹훅 이벤트 (입금 웹훅 본문의 event)
  BANK_DEPOSIT_WEBHOOK_EVENT_RECEIVED           = 400 # 입금 알림을 처음 저장했다 (주문 연결 전)
  BANK_DEPOSIT_WEBHOOK_EVENT_MATCHED            = 401 # 입금대기 주문 한 건과 연결되어 입금 확인됐다
  BANK_DEPOSIT_WEBHOOK_EVENT_AMBIGUOUS          = 402 # 같은 금액의 입금대기 주문이 여럿이라 판매자가 골라야 한다
  BANK_DEPOSIT_WEBHOOK_EVENT_UNMATCHED          = 403 # 연결할 입금대기 주문이 없다
  BANK_DEPOSIT_WEBHOOK_EVENT_CONFIRMED_MANUALLY = 404 # 판매자가 관리자에서 직접 입금을 확인했다
  BANK_DEPOSIT_WEBHOOK_EVENT_EXPIRED            = 405 # 입금 기한이 지나 닫혔다
  BANK_DEPOSIT_WEBHOOK_EVENT_CANCELLED          = 406 # 입금대기 중인 주문을 취소했다
  BANK_DEPOSIT_WEBHOOK_EVENT_REVERTED           = 407 # 입금 확인을 되돌려 다시 입금대기로 바꿨다

  included do
    # 판매자 입금 계좌 목록 (GET /v1/sdk/deposits/accounts) — supervisor 전용
    # @comment_by Claude
    # @date: 26-11-12
    # 첫 계좌가 대표 계좌(primary: true)다.
    def deposit_accounts(idempotency_key: nil)
      request(
        uri:     'sdk/deposits/accounts',
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        }
      )
    end

    # 입금 웹훅 서명 비밀값 발급 (POST /v1/sdk/deposits/webhook_secret) — supervisor 전용
    # @comment_by Claude
    # @date: 26-11-12
    # ⚠️ 원문은 이 응답에서만 오고, 부를 때마다 바뀐다.
    # 웹훅은 X-Bootpay-Signature: sha256=HMAC_SHA256(secret, "{X-Bootpay-Timestamp}.{raw_body}") 로 서명된다.
    def deposit_webhook_secret(idempotency_key: nil)
      request(
        uri:     'sdk/deposits/webhook_secret',
        method:  :post,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        }
      )
    end

    # 입금대기 등록 (POST /v1/sdk/deposits) — supervisor 전용
    # @comment_by Claude
    # @date: 26-11-12
    # 같은 merchant_order_id 로 금액·입금자명·계좌가 같은 재호출은 기존 주문을 돌려주고, 하나라도 다르면 18110.
    # webhook_url 을 주려면 deposit_webhook_secret 으로 비밀값을 먼저 발급받아야 한다(18131).
    # notify(구매자 알림톡, 유료): { deposit_guide:, deposit_paid:, link: } — buyer_phone 필수(18134), link 는 https(18135).
    def deposit_create(merchant_order_id:, price:, depositor:, order_name: nil, memo: nil, buyer_name: nil,
                       buyer_phone: nil, buyer_email: nil, account_id: nil, webhook_url: nil, notify: nil,
                       idempotency_key: nil)
      request(
        uri:     'sdk/deposits',
        method:  :post,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        },
        payload: {
                   merchant_order_id: merchant_order_id,
                   price:             price,
                   depositor:         depositor,
                   order_name:        order_name,
                   memo:              memo,
                   buyer_name:        buyer_name,
                   buyer_phone:       buyer_phone,
                   buyer_email:       buyer_email,
                   account_id:        account_id,
                   webhook_url:       webhook_url,
                   notify:            notify.is_a?(Hash) ? notify.compact : notify
                 }.compact
      )
    end

    # 입금대기 조회 (GET /v1/sdk/deposits/:id) — supervisor 전용
    # @comment_by Claude
    # @date: 26-11-12
    # deposit_id 는 가맹점 주문번호(merchant_order_id) 또는 부트페이 주문번호. 자유 문자열이라 경로 인코딩한다.
    def deposit_detail(deposit_id:, idempotency_key: nil)
      request(
        uri:     "sdk/deposits/#{deposit_path_segment(deposit_id)}",
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        }
      )
    end

    # 입금대기 취소 (DELETE /v1/sdk/deposits/:id) — supervisor 전용
    # @comment_by Claude
    # @date: 26-11-12
    # 이미 닫힌 주문은 그대로 돌려준다. 입금 확인된 주문은 18108.
    def deposit_cancel(deposit_id:, idempotency_key: nil)
      request(
        uri:     "sdk/deposits/#{deposit_path_segment(deposit_id)}",
        method:  :delete,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        }
      )
    end

    private

    # 경로 세그먼트 인코딩 — 공백은 %20, / 는 %2F (다른 SDK 와 같은 결과)
    def deposit_path_segment(value)
      URI.encode_www_form_component(value.to_s).gsub('+', '%20')
    end
  end
end
