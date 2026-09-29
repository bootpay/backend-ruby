module BootpayStore::Concern::Inquiry
  extend ActiveSupport::Concern

  included do
    # 1:1 문의 목록 (GET /v1/inquiries)
    # @comment_by Claude
    # @date: 26-09-29
    # 회원 모드: user_id(Bootpay 회원 _id 또는 외부 회원 ID)·login_id·user_jwt 중 하나로 회원을 정하고 본인 문의만 본다.
    # supervisor: true 면 몰 전체 문의 — 이때 user_id 는 작성 회원 필터(선택)다.
    # answered: true 답변 완료만 / false 미답변만 / nil 전체
    def inquiries(user_id: nil, login_id: nil, user_jwt: nil, answered: nil, page: 1, limit: 20,
                  supervisor: false, idempotency_key: nil)
      request(
        uri:     'inquiries',
        method:  :get,
        headers: {
          'Idempotency-Key'  => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'     => supervisor ? 'supervisor' : 'user',
          'Bootpay-User-JWT' => user_jwt
        }.compact,
        params:  {
                   user_id:  user_id,
                   login_id: login_id,
                   answered: answered.nil? ? nil : answered.to_s,
                   page:     page,
                   limit:    limit
                 }.compact
      )
    end

    # 1:1 문의 단건 (GET /v1/inquiries/:id)
    # @comment_by Claude
    # @date: 26-09-29
    # 회원 모드는 작성 회원 본인 문의만(다른 회원 문의는 404). supervisor: true 면 몰의 모든 문의.
    def inquiry_detail(inquiry_id:, user_id: nil, login_id: nil, user_jwt: nil, supervisor: false, idempotency_key: nil)
      request(
        uri:     "inquiries/#{inquiry_id}",
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

    # 1:1 문의 작성 (POST /v1/inquiries) — 회원 전용
    # @comment_by Claude
    # @date: 26-09-29
    # product_id 는 이 몰의 상품, order_id 는 작성 회원의 주문이어야 한다. option 은 상품 옵션 문구(product_id 필요).
    def inquiry_create(content:, user_id: nil, login_id: nil, user_jwt: nil, title: nil, product_id: nil,
                       option: nil, order_id: nil, idempotency_key: nil)
      request(
        uri:     'inquiries',
        method:  :post,
        headers: {
          'Idempotency-Key'  => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'     => 'user',
          'Bootpay-User-JWT' => user_jwt
        }.compact,
        payload: {
                   user_id:    user_id,
                   login_id:   login_id,
                   title:      title,
                   content:    content,
                   product_id: product_id,
                   option:     option,
                   order_id:   order_id
                 }.compact
      )
    end

    # 1:1 문의 수정 (PUT /v1/inquiries/:id) — 작성 회원 본인, 답변 전만
    # @comment_by Claude
    # @date: 26-09-29
    # 답변이 달린 문의는 409 INQUIRY_ALREADY_ANSWERED. title 에 '' 를 보내면 제목을 지운다.
    def inquiry_update(inquiry_id:, user_id: nil, login_id: nil, user_jwt: nil, title: nil, content: nil,
                       idempotency_key: nil)
      request(
        uri:     "inquiries/#{inquiry_id}",
        method:  :put,
        headers: {
          'Idempotency-Key'  => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'     => 'user',
          'Bootpay-User-JWT' => user_jwt
        }.compact,
        payload: {
                   user_id:  user_id,
                   login_id: login_id,
                   title:    title,
                   content:  content
                 }.compact
      )
    end

    # 1:1 문의 삭제 (DELETE /v1/inquiries/:id) — 작성 회원 본인 또는 supervisor
    # @comment_by Claude
    # @date: 26-09-29
    # 달린 답변도 함께 삭제된다.
    def inquiry_delete(inquiry_id:, user_id: nil, login_id: nil, user_jwt: nil, supervisor: false, idempotency_key: nil)
      request(
        uri:     "inquiries/#{inquiry_id}",
        method:  :delete,
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

    # 1:1 문의 답변 등록·수정 (PUT /v1/inquiries/:id/answer) — supervisor 전용
    # @comment_by Claude
    # @date: 26-09-29
    # 답변이 없으면 만들고, 있으면 내용을 바꾼다. 응답은 답변이 반영된 문의 객체다.
    def inquiry_answer(inquiry_id:, content:, idempotency_key: nil)
      request(
        uri:     "inquiries/#{inquiry_id}/answer",
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
