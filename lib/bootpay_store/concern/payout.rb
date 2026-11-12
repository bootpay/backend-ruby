module BootpayStore::Concern::Payout
  extend ActiveSupport::Concern

  included do
    # 입점사 지급 요청 등록 (POST /v1/sdk/payouts) — supervisor 전용
    # @comment_by Claude
    # @date: 26-11-12
    # 가맹점 지정 금액(manual) 정산 쇼핑몰이 입점사와 지급액을 정해 지급 원장에 등록한다. 실제 송금은 부트페이 배치가 한다.
    # 같은 merchant_payout_id 재호출은 처음 만든 항목을 돌려준다(금액·입점사·지급일은 바꿀 수 없다).
    # payout_date: 'YYYY-MM-DD' (미지정시 오늘). 정산 방식이 manual 이 아니면 18360, PG 미등록 입점사는 18378.
    def payout_create(sub_seller_id:, amount:, merchant_payout_id:, order_number: nil, payout_date: nil,
                      idempotency_key: nil)
      request(
        uri:     'sdk/payouts',
        method:  :post,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        },
        payload: {
                   sub_seller_id:      sub_seller_id,
                   amount:             amount,
                   merchant_payout_id: merchant_payout_id,
                   order_number:       order_number,
                   payout_date:        payout_date
                 }.compact
      )
    end

    # 입점사 지급 항목 조회 (GET /v1/sdk/payouts/:id) — supervisor 전용
    # @comment_by Claude
    # @date: 26-11-12
    # payout_id 는 merchant_payout_id 또는 지급 항목 id. 없으면 404 PAYOUT_RESULT_INVALID(18366).
    def payout_detail(payout_id:, idempotency_key: nil)
      request(
        uri:     "sdk/payouts/#{URI.encode_www_form_component(payout_id.to_s).gsub('+', '%20')}",
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        }
      )
    end

    # 입점사 지급 목록 (GET /v1/sdk/payouts) — supervisor 전용
    # @comment_by Claude
    # @date: 26-11-12
    # 최근 생성 순. 응답 data 는 항목 배열이다(전체 개수 없음 — 받은 수가 limit 보다 적으면 마지막 페이지).
    # status: ready · held · sending · requested · processing · succeeded · failed · cancelled · unknown · void
    def payouts(status: nil, sub_seller_id: nil, from: nil, to: nil, page: nil, limit: nil, idempotency_key: nil)
      request(
        uri:     'sdk/payouts',
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        },
        params:  {
                   status:        status,
                   sub_seller_id: sub_seller_id,
                   from:          from,
                   to:            to,
                   page:          page,
                   limit:         limit
                 }.compact
      )
    end
  end
end
