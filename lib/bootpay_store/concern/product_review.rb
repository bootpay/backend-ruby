module BootpayStore::Concern::ProductReview
  extend ActiveSupport::Concern

  included do
    # 상품평 목록 (GET /v1/reviews)
    # @comment_by Claude
    # @date: 26-09-29
    # 회원 모드: user_id·login_id·user_jwt 로 정한 회원이 쓴 상품평만 본다.
    # supervisor: true 면 몰 전체 상품평 — 이때 user_id 는 작성 회원 필터(선택)다.
    # 상품 상세의 공개 상품평 목록은 기존 GET /v1/products/:id/reviews 를 쓴다.
    def reviews(page: 1, limit: 20, product_id: nil, view: nil, user_id: nil, login_id: nil, user_jwt: nil,
                supervisor: false, idempotency_key: nil)
      request(
        uri:     'reviews',
        method:  :get,
        headers: {
          'Idempotency-Key'  => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'     => supervisor ? 'supervisor' : 'user',
          'Bootpay-User-JWT' => user_jwt
        }.compact,
        params:  {
                   page:       page,
                   limit:      limit,
                   product_id: product_id,
                   view:       view,
                   user_id:    user_id,
                   login_id:   login_id
                 }.compact
      )
    end

    # 상품평 단건 (GET /v1/reviews/:id)
    # @comment_by Claude
    # @date: 26-09-29
    # 공개 상품평은 누구나, 숨김 상품평은 작성 회원 본인 또는 supervisor 만 본다.
    def review_detail(product_review_id:, user_id: nil, login_id: nil, user_jwt: nil, supervisor: false,
                      idempotency_key: nil)
      request(
        uri:     "reviews/#{product_review_id}",
        method:  :get,
        headers: {
          'Idempotency-Key'  => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'     => supervisor ? 'supervisor' : 'user',
          'Bootpay-User-JWT' => user_jwt
        }.compact,
        params:  {
                   user_id:  user_id,
                   login_id: login_id
                 }.compact
      )
    end

    # 상품평 작성 (POST /v1/reviews) — 회원 전용
    # @comment_by Claude
    # @date: 26-09-29
    # order_id 는 회원의 구매확정 주문, product_id(·product_option_id)는 그 주문에 담긴 상품이어야 한다.
    # images 는 사진 URL 최대 5개(문자열 또는 { url: } 해시). 파일 업로드는 지원하지 않는다.
    def review_create(order_id:, product_id:, rating:, content:, product_option_id: nil, images: nil,
                      user_id: nil, login_id: nil, user_jwt: nil, idempotency_key: nil)
      request(
        uri:     'reviews',
        method:  :post,
        headers: {
          'Idempotency-Key'  => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'     => 'user',
          'Bootpay-User-JWT' => user_jwt
        }.compact,
        payload: {
                   user_id:           user_id,
                   login_id:          login_id,
                   order_id:          order_id,
                   product_id:        product_id,
                   product_option_id: product_option_id,
                   rating:            rating,
                   content:           content,
                   images:            images
                 }.compact
      )
    end

    # 상품평 수정 (PUT /v1/reviews/:id) — 작성 회원 본인, 작성 후 7일 이내
    # @comment_by Claude
    # @date: 26-09-29
    # images 는 보내면 통째로 교체한다([] 면 모두 삭제). 7일이 지나면 REVIEW_EDIT_TIME_EXPIRED.
    def review_update(product_review_id:, rating: nil, content: nil, images: nil,
                      user_id: nil, login_id: nil, user_jwt: nil, idempotency_key: nil)
      request(
        uri:     "reviews/#{product_review_id}",
        method:  :put,
        headers: {
          'Idempotency-Key'  => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'     => 'user',
          'Bootpay-User-JWT' => user_jwt
        }.compact,
        payload: {
                   user_id:  user_id,
                   login_id: login_id,
                   rating:   rating,
                   content:  content,
                   images:   images
                 }.compact
      )
    end

    # 상품평 삭제 (DELETE /v1/reviews/:id) — 작성 회원 본인 또는 supervisor
    # @comment_by Claude
    # @date: 26-09-29
    # 지급된 적립금 회수·상품 통계 차감이 함께 일어난다. reason 은 운영자 모드의 삭제 사유.
    def review_delete(product_review_id:, reason: nil, user_id: nil, login_id: nil, user_jwt: nil,
                      supervisor: false, idempotency_key: nil)
      request(
        uri:     "reviews/#{product_review_id}",
        method:  :delete,
        headers: {
          'Idempotency-Key'  => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'     => supervisor ? 'supervisor' : 'user',
          'Bootpay-User-JWT' => user_jwt
        }.compact,
        params:  {
                   user_id:  user_id,
                   login_id: login_id,
                   reason:   reason
                 }.compact
      )
    end

    # 상품평 판매자 답글 등록·수정 (PUT /v1/reviews/:id/reply) — supervisor 전용
    # @comment_by Claude
    # @date: 26-09-29
    # 답글이 없으면 만들고, 있으면 내용을 바꾼다(10자 이상). 응답은 답글이 반영된 상품평 객체다.
    def review_reply(product_review_id:, content:, idempotency_key: nil)
      request(
        uri:     "reviews/#{product_review_id}/reply",
        method:  :put,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        },
        payload: {
          content: content
        }
      )
    end
  end
end
