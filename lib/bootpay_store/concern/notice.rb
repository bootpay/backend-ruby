module BootpayStore::Concern::Notice
  extend ActiveSupport::Concern

  included do
    # 공지사항 목록 (GET /v1/notices)
    # @comment_by Claude
    # @date: 26-09-29
    # supervisor: true 면 운영자 모드(Bootpay-Role: supervisor) — view: 'all' 로 비공개 공지까지 조회할 수 있다.
    # 고객 모드는 몰 공지사항 사용여부가 꺼져 있으면 BOARD_FEATURE_DISABLED 로 거절된다.
    def notices(page: 1, limit: 20, keyword: nil, view: nil, supervisor: false, idempotency_key: nil)
      request(
        uri:     'notices',
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => supervisor ? 'supervisor' : 'user'
        },
        params:  {
                   page:    page,
                   limit:   limit,
                   keyword: keyword,
                   view:    view
                 }.compact
      )
    end

    # 공지사항 단건 (GET /v1/notices/:id)
    # @comment_by Claude
    # @date: 26-09-29
    # 비공개 공지는 supervisor: true 일 때만 보인다(아니면 404 POST_NOT_FOUND).
    def notice_detail(notice_id:, supervisor: false, idempotency_key: nil)
      request(
        uri:     "notices/#{notice_id}",
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => supervisor ? 'supervisor' : 'user'
        }
      )
    end

    # 공지사항 등록 (POST /v1/notices) — supervisor 전용
    # @comment_by Claude
    # @date: 26-09-29
    def notice_create(title:, content:, images: nil, is_notice: nil, is_display: nil, idempotency_key: nil)
      request(
        uri:     'notices',
        method:  :post,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        },
        payload: {
                   title:      title,
                   content:    content,
                   images:     images,
                   is_notice:  is_notice,
                   is_display: is_display
                 }.compact
      )
    end

    # 공지사항 수정 (PUT /v1/notices/:id) — supervisor 전용
    # @comment_by Claude
    # @date: 26-09-29
    # 보낸 필드만 바뀐다. images 는 보내면 목록 전체를 교체한다([] 면 모두 삭제).
    def notice_update(notice_id:, title: nil, content: nil, images: nil, is_notice: nil, is_display: nil,
                      idempotency_key: nil)
      request(
        uri:     "notices/#{notice_id}",
        method:  :put,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        },
        payload: {
                   title:      title,
                   content:    content,
                   images:     images,
                   is_notice:  is_notice,
                   is_display: is_display
                 }.compact
      )
    end

    # 공지사항 삭제 (DELETE /v1/notices/:id) — supervisor 전용
    # @comment_by Claude
    # @date: 26-09-29
    def notice_delete(notice_id:, idempotency_key: nil)
      request(
        uri:     "notices/#{notice_id}",
        method:  :delete,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        }
      )
    end
  end
end
