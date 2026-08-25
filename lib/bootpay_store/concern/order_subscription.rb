module BootpayStore::Concern::OrderSubscription
  extend ActiveSupport::Concern
  included do
    # 계약된 구독정보를 가져온다
    # Comment by GOSOMI
    # @date: 2025-06-20
    # @date: 26-08-14 limit 인자 추가. 서버(v1/order_subscriptions_controller#index)는
    #   `params[:limit].presence || 20` 으로 이미 받고 있었는데 SDK 가 안 보내고 있었다.
    #   기본값 20 은 서버 기본과 같아 기존 호출 결과가 바뀌지 않는다.
    #   ⚠️ 날짜 키는 search_date_from/to (또는 s_at/e_at). orders 의 css_at/cse_at 와 다르다.
    def order_subscriptions(page: 1, limit: 20, keyword: nil, search_date_from: nil, search_date_to: nil,
                            request_type: nil, user_group_id: nil, status: nil, user_id: nil, idempotency_key: nil)
      request(
        uri:     'order_subscriptions',
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        params:  {
                   page:             page,
                   limit:            limit,
                   keyword:          keyword,
                   search_date_from: search_date_from,
                   search_date_to:   search_date_to,
                   request_type:     request_type,
                   user_group_id:    user_group_id,
                   status:           status,
                   user_id:          user_id
                 }.compact
      )
    end

    # 구독 상세를 조회한다
    def order_subscription_detail(order_subscription_id:, idempotency_key: nil)
      request(
        uri:     "order_subscriptions/#{order_subscription_id}",
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        }
      )
    end

    # ─────────────────────────────────────────────────────────────
    # 구독 계약변경 · 조정항목 · 빌 조회   (@comment_by Claude (alfred) / @date: 26-08-14)
    # ─────────────────────────────────────────────────────────────

    # 구독 계약 내용을 변경한다 (PUT /v1/order_subscriptions/:id)
    # 바뀐 값만 보내면 된다 (나머지는 서버가 그대로 유지).
    #
    # price 는 회차별 결제 금액의 **기준금액**이다. 바꾸면 결제예정(READY) 회차의 청구액이
    # 즉시 다시 계산되고, 이후 회차도 이 금액으로 만들어진다. 이미 결제된 회차는 그대로다.
    # 0 이하는 받지 않는다. 특정 회차만 가감하려면 order_subscription_adjustment_create 를 쓴다.
    # (관리자 화면의 금액 변경과 같은 구현을 탄다) (@date: 26-08-24)
    def order_subscription_update(order_subscription_id:, product_id: nil, product_option_id: nil,
                                  order_name: nil, total_subscription_duration: nil, quantity: nil,
                                  address_id: nil, username: nil, phone: nil, email: nil,
                                  use_free_trial: nil, free_trial_day: nil,
                                  service_start_at: nil, service_end_at: nil, price: nil,
                                  idempotency_key: nil)
      request(
        uri:     "order_subscriptions/#{order_subscription_id}",
        method:  :put,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        },
        payload: {
                   product_id:                  product_id,
                   product_option_id:           product_option_id,
                   order_name:                  order_name,
                   total_subscription_duration: total_subscription_duration,
                   quantity:                    quantity,
                   address_id:                  address_id,
                   username:                    username,
                   phone:                       phone,
                   email:                       email,
                   use_free_trial:              use_free_trial,
                   free_trial_day:              free_trial_day,
                   service_start_at:            service_start_at,
                   service_end_at:              service_end_at,
                   price:                       price
                 }.compact
      )
    end

    # 가감산 조정항목을 추가한다 (POST /v1/order_subscriptions/:id/adjustments)
    # ⚠️ /adjustments 한 경로에 POST·PUT·DELETE 세 동사가 걸려 있다. method 를 반드시 명시할 것.
    # type 미전달 시 서버가 price>0 이면 SETUP_PRICE, 아니면 PERIOD_DISCOUNT 로 자동 판정한다.
    #
    # 회차 지정 방법 3가지 (아래로 갈수록 넓다):
    #   - duration: 5                      → 5회차 한 건만
    #   - duration_from: 3, duration_to: 7 → 3~7회차 각각 한 건씩 (총 5건)
    #   - duration_from: 3, is_unlimited: true → 3회차부터 계약 끝까지 (레코드는 1건, duration_to 는 무시)
    # 상한은 계약 총회차이며, 총회차가 무제한인 계약은 60회차까지다.
    # 이미 결제가 끝난 회차는 거절된다. 범위 중 한 회차라도 최종 금액이 음수면 전부 거절된다(부분 반영 없음).
    def order_subscription_adjustment_create(order_subscription_id:, name: nil, price: 0, duration: 1,
                                             tax_free_price: 0, type: nil, duration_from: nil,
                                             duration_to: nil, is_unlimited: nil, idempotency_key: nil)
      request(
        uri:     "order_subscriptions/#{order_subscription_id}/adjustments",
        method:  :post,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        },
        payload: {
                   name:           name,
                   price:          price,
                   duration:       duration,
                   tax_free_price: tax_free_price,
                   type:           type,
                   duration_from:  duration_from,
                   duration_to:    duration_to,
                   is_unlimited:   is_unlimited
                 }.compact
      )
    end

    # 특정 회차의 조정항목을 통째로 교체한다 (PUT /v1/order_subscriptions/:id/adjustments)
    # adjustments 는 배열. 서버는 duration(회차) 단위로 갈아끼운다.
    def order_subscription_adjustment_update(order_subscription_id:, duration: 1, adjustments: [],
                                             idempotency_key: nil)
      request(
        uri:     "order_subscriptions/#{order_subscription_id}/adjustments",
        method:  :put,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        },
        payload: {
                   duration:    duration,
                   adjustments: adjustments
                 }.compact
      )
    end

    # 조정항목을 삭제한다 (DELETE /v1/order_subscriptions/:id/adjustments)
    def order_subscription_adjustment_delete(order_subscription_id:, order_subscription_adjustment_id:,
                                             idempotency_key: nil)
      request(
        uri:     "order_subscriptions/#{order_subscription_id}/adjustments",
        method:  :delete,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        },
        payload: { order_subscription_adjustment_id: order_subscription_adjustment_id }
      )
    end

    # 구독 빌(회차) 목록을 조회한다 (GET /v1/order_subscription_bills)
    # ⚠️ 경로가 order_subscription_bills — 언더스코어다 (하이픈 아님).
    def order_subscription_bill_list(order_subscription_id: nil, page: 1, limit: 20, status: nil,
                                     idempotency_key: nil)
      request(
        uri:     'order_subscription_bills',
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        params:  {
                   order_subscription_id: order_subscription_id,
                   page:                  page,
                   limit:                 limit,
                   status:                status
                 }.compact
      )
    end

    # ─────────────────────────────────────────────────────────────
    # 구독 진행중 요청 (requests/ing)   (@comment_by Claude (alfred) / @date: 26-08-14)
    #
    # ⚠️ 동사가 제각각이다. routes 정본 기준:
    #     pause · purchase · termination · transfer  → POST
    #     resume                                     → PUT   ← 이것만 다르다
    #     calculate_termination_fee                  → GET
    #   "오타겠지" 하며 resume 을 POST 로 바꾸지 말 것.
    #
    # ⚠️ supervisor_request_order_subscription_* (PUT order_subscriptions/:id/*) 와는 다른 라우트다.
    #   이쪽은 구매자가 "요청"을 올리는 면, 저쪽은 관리자가 즉시 실행하는 면.
    # ─────────────────────────────────────────────────────────────

    # 구독 일시중지 요청 (POST /v1/order_subscriptions/requests/ing/pause)
    def order_subscription_requests_ing_pause(order_subscription_id:, reason: nil, paused_at: nil,
                                              expected_resume_at: nil, idempotency_key: nil)
      request(
        uri:     'order_subscriptions/requests/ing/pause',
        method:  :post,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        payload: {
                   order_subscription_id: order_subscription_id,
                   reason:                reason,
                   paused_at:             paused_at,
                   expected_resume_at:    expected_resume_at
                 }.compact
      )
    end

    # 구독 재개 요청 (PUT /v1/order_subscriptions/requests/ing/resume)
    # ⚠️ requests/ing 계열 중 유일하게 PUT 이다.
    def order_subscription_requests_ing_resume(order_subscription_id:, reason: nil, idempotency_key: nil)
      request(
        uri:     'order_subscriptions/requests/ing/resume',
        method:  :put,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        payload: {
                   order_subscription_id: order_subscription_id,
                   reason:                reason
                 }.compact
      )
    end

    # 중도인수 요청 (POST /v1/order_subscriptions/requests/ing/purchase)
    def order_subscription_requests_ing_purchase(order_subscription_id:, price: nil, tax_free_price: nil,
                                                 reason: nil, idempotency_key: nil)
      request(
        uri:     'order_subscriptions/requests/ing/purchase',
        method:  :post,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        payload: {
                   order_subscription_id: order_subscription_id,
                   price:                 price,
                   tax_free_price:        tax_free_price,
                   reason:                reason
                 }.compact
      )
    end

    # 중도해지 요청 (POST /v1/order_subscriptions/requests/ing/termination)
    def order_subscription_requests_ing_termination(order_subscription_id:, order_number: nil, reason: nil,
                                                    termination_fee: nil, last_bill_refund_price: nil,
                                                    final_fee: nil, service_end_at: nil, idempotency_key: nil)
      request(
        uri:     'order_subscriptions/requests/ing/termination',
        method:  :post,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        payload: {
                   order_subscription_id:  order_subscription_id,
                   order_number:           order_number,
                   reason:                 reason,
                   termination_fee:        termination_fee,
                   last_bill_refund_price: last_bill_refund_price,
                   final_fee:              final_fee,
                   service_end_at:         service_end_at
                 }.compact
      )
    end

    # 구독 이전/승계 요청 (POST /v1/order_subscriptions/requests/ing/transfer)
    def order_subscription_requests_ing_transfer(order_subscription_id:, new_user_id: nil, new_username: nil,
                                                 new_user_email: nil, new_user_phone: nil, new_user_address: nil,
                                                 wallet_id: nil, reason: nil, idempotency_key: nil)
      request(
        uri:     'order_subscriptions/requests/ing/transfer',
        method:  :post,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        payload: {
                   order_subscription_id: order_subscription_id,
                   new_user_id:           new_user_id,
                   new_username:          new_username,
                   new_user_email:        new_user_email,
                   new_user_phone:        new_user_phone,
                   new_user_address:      new_user_address,
                   wallet_id:             wallet_id,
                   reason:                reason
                 }.compact
      )
    end

    # 중도해지 수수료 사전계산 (GET /v1/order_subscriptions/requests/ing/calculate_termination_fee)
    # 해지 요청 전에 얼마가 나오는지 미리 보여줄 때 쓴다.
    def order_subscription_calculate_termination_fee(order_subscription_id:, order_number: nil,
                                                     idempotency_key: nil)
      request(
        uri:     'order_subscriptions/requests/ing/calculate_termination_fee',
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        params:  {
                   order_subscription_id: order_subscription_id,
                   order_number:          order_number
                 }.compact
      )
    end

    # ─────────────────────────────────────────────────────────────
    # 구독 요청 리소스 (order-subscription-requests)  ⚠️ 하이픈 경로
    #   하이픈 경로는 order-subscription-requests 와 user-groups 둘뿐이다.
    #   order_subscriptions · order_subscription_bills 는 언더스코어 — 복사해 고칠 때 가장 흔히 틀리는 지점.
    # ─────────────────────────────────────────────────────────────

    # 구독 변경요청 목록 (GET /v1/order-subscription-requests)
    # project_id 를 주면 supervisor 모드(프로젝트 전체 검색), 없으면 본인 요청만.
    def order_subscription_request_list(project_id: nil, order_subscription_id: nil, page: 1, limit: 20,
                                        keyword: nil, s_at: nil, e_at: nil, status: nil,
                                        request_type: nil, user_id: nil, user_group_id: nil,
                                        idempotency_key: nil)
      request(
        uri:     'order-subscription-requests',
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => project_id.present? ? 'supervisor' : 'user'
        },
        params:  {
                   project_id:            project_id,
                   order_subscription_id: order_subscription_id,
                   page:                  page,
                   limit:                 limit,
                   keyword:               keyword,
                   s_at:                  s_at,
                   e_at:                  e_at,
                   status:                status,
                   request_type:          request_type,
                   user_id:               user_id,
                   user_group_id:         user_group_id
                 }.compact
      )
    end

    # 구독 변경요청 상세 (GET /v1/order-subscription-requests/:id)
    def order_subscription_request_detail(request_history_id:, project_id: nil, idempotency_key: nil)
      request(
        uri:     "order-subscription-requests/#{request_history_id}",
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => project_id.present? ? 'supervisor' : 'user'
        },
        params:  { project_id: project_id }.compact
      )
    end

    # 구독 변경요청 승인/반려 (PUT /v1/order-subscription-requests/:id)
    # ⚠️ 승인과 반려는 별도 액션이 아니다. 라우트는 index/show/update 셋뿐이고
    #   approval: 'approve' | 'reject' 파라미터로 갈린다.
    #   서버가 params[:action] 을 Rails 예약어로 쓰기 때문에 키 이름이 approval 이다.
    def order_subscription_request_update(request_history_id:, approval:, reason: nil,
                                          price: nil, tax_free_price: nil, termination_fee: nil,
                                          last_bill_refund_price: nil, final_fee: nil, service_end_at: nil,
                                          idempotency_key: nil)
      request(
        uri:     "order-subscription-requests/#{request_history_id}",
        method:  :put,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        },
        payload: {
                   approval:               approval,
                   reason:                 reason,
                   price:                  price,
                   tax_free_price:         tax_free_price,
                   termination_fee:        termination_fee,
                   last_bill_refund_price: last_bill_refund_price,
                   final_fee:              final_fee,
                   service_end_at:         service_end_at
                 }.compact
      )
    end
  end
end