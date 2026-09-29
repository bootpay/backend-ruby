module BootpayStore::Concern::ProductQna
  extend ActiveSupport::Concern

  included do
    # 상품문의 목록 (GET /v1/product-qnas)
    # @comment_by Claude
    # @date: 26-09-29
    # 고객 모드는 product_id 필수. 다른 사람의 비밀글은 is_viewable: false 로 본문 없이 온다.
    # 회원(user_id·login_id·user_jwt)을 보내면 그 회원이 쓴 비밀글 본문이 보인다.
    # supervisor: true + view: 'all' 이면 몰 전체(숨김 포함) — 이때 product_id 는 선택 필터다.
    def product_qnas(product_id: nil, view: nil, page: 1, limit: 20, user_id: nil, login_id: nil, user_jwt: nil,
                     supervisor: false, idempotency_key: nil)
      request(
        uri:     'product-qnas',
        method:  :get,
        headers: {
          'Idempotency-Key'  => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'     => supervisor ? 'supervisor' : 'user',
          'Bootpay-User-JWT' => user_jwt
        }.compact,
        params:  {
                   product_id: product_id,
                   view:       view,
                   page:       page,
                   limit:      limit,
                   user_id:    user_id,
                   login_id:   login_id
                 }.compact
      )
    end

    # 상품문의 단건 (GET /v1/product-qnas/:id)
    # @comment_by Claude
    # @date: 26-09-29
    # 다른 사람의 비밀글은 403 PRODUCT_QNA_SECRET_FORBIDDEN. supervisor: true 면 비밀글·숨김 글도 본다.
    def product_qna_detail(product_qna_id:, user_id: nil, login_id: nil, user_jwt: nil, supervisor: false,
                           idempotency_key: nil)
      request(
        uri:     "product-qnas/#{product_qna_id}",
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

    # 상품문의 작성 (POST /v1/product-qnas)
    # @comment_by Claude
    # @date: 26-09-29
    # 회원(user_id·login_id·user_jwt) 또는 비회원(guest_name + guest_password, 몰이 비회원 작성을 허용할 때).
    # 회원 문의면 guest_* 는 무시된다.
    def product_qna_create(product_id:, content:, title: nil, product_option_id: nil, option_text: nil,
                           is_secret: nil, guest_name: nil, guest_password: nil,
                           user_id: nil, login_id: nil, user_jwt: nil, idempotency_key: nil)
      request(
        uri:     'product-qnas',
        method:  :post,
        headers: {
          'Idempotency-Key'  => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'     => 'user',
          'Bootpay-User-JWT' => user_jwt
        }.compact,
        payload: {
                   product_id:        product_id,
                   title:             title,
                   content:           content,
                   product_option_id: product_option_id,
                   option_text:       option_text,
                   is_secret:         is_secret,
                   guest_name:        guest_name,
                   guest_password:    guest_password,
                   user_id:           user_id,
                   login_id:          login_id
                 }.compact
      )
    end

    # 상품문의 수정 (PUT /v1/product-qnas/:id) — 작성 회원 본인 또는 비회원 비밀번호, 답변 전만
    # @comment_by Claude
    # @date: 26-09-29
    # 답변이 달린 문의는 409 PRODUCT_QNA_ALREADY_ANSWERED, 비회원 비밀번호가 틀리면 403 PRODUCT_QNA_GUEST_PASSWORD_INVALID.
    def product_qna_update(product_qna_id:, title: nil, content: nil, is_secret: nil, guest_password: nil,
                           user_id: nil, login_id: nil, user_jwt: nil, idempotency_key: nil)
      request(
        uri:     "product-qnas/#{product_qna_id}",
        method:  :put,
        headers: {
          'Idempotency-Key'  => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'     => 'user',
          'Bootpay-User-JWT' => user_jwt
        }.compact,
        payload: {
                   title:          title,
                   content:        content,
                   is_secret:      is_secret,
                   guest_password: guest_password,
                   user_id:        user_id,
                   login_id:       login_id
                 }.compact
      )
    end

    # 상품문의 삭제 (DELETE /v1/product-qnas/:id) — 작성 회원 본인·비회원 비밀번호 또는 supervisor
    # @comment_by Claude
    # @date: 26-09-29
    # guest_password 는 URL 쿼리가 아닌 본문으로 보낸다(서버는 둘 다 받는다).
    def product_qna_delete(product_qna_id:, guest_password: nil, user_id: nil, login_id: nil, user_jwt: nil,
                           supervisor: false, idempotency_key: nil)
      request(
        uri:     "product-qnas/#{product_qna_id}",
        method:  :delete,
        headers: {
          'Idempotency-Key'  => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'     => supervisor ? 'supervisor' : 'user',
          'Bootpay-User-JWT' => user_jwt
        }.compact,
        payload: {
                   guest_password: guest_password,
                   user_id:        user_id,
                   login_id:       login_id
                 }.compact
      )
    end

    # 상품문의 답변 등록·수정 (PUT /v1/product-qnas/:id/answer) — supervisor 전용
    # @comment_by Claude
    # @date: 26-09-29
    # 답변이 없으면 만들고, 있으면 내용을 바꾼다. 응답은 답변이 반영된 상품문의 객체다.
    def product_qna_answer(product_qna_id:, content:, idempotency_key: nil)
      request(
        uri:     "product-qnas/#{product_qna_id}/answer",
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
