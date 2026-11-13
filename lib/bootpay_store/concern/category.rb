module BootpayStore::Concern::Category
  extend ActiveSupport::Concern

  included do
    # 카테고리 목록 (GET /v1/categories)
    # @comment_by Claude (alfred)
    # @date: 26-11-13
    def category_list(idempotency_key: nil)
      request(
        uri:     'categories',
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        }
      )
    end

    # 카테고리 상세 (GET /v1/categories/:id)
    # @comment_by Claude (alfred)
    # @date: 26-11-13
    def category_detail(category_id:, idempotency_key: nil)
      request(
        uri:     "categories/#{category_id}",
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        }
      )
    end

    # 카테고리 생성 (POST /v1/categories)
    # @comment_by Claude (alfred)
    # @date: 26-11-13
    # supervisor 전용
    def category_create(name:, parent_category_id: nil, status_display: nil, status_best: nil,
                        filter_color: nil, filter_size: nil, idempotency_key: nil)
      request(
        uri:     'categories',
        method:  :post,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        },
        payload: {
                   name:               name,
                   parent_category_id: parent_category_id,
                   status_display:     status_display,
                   status_best:        status_best,
                   filter_color:       filter_color,
                   filter_size:        filter_size
                 }.compact
      )
    end

    # 카테고리 수정 (PUT /v1/categories/:id)
    # @comment_by Claude (alfred)
    # @date: 26-11-13
    # supervisor 전용
    def category_update(category_id:, name: nil, parent_category_id: nil, status_display: nil, status_best: nil,
                        filter_color: nil, filter_size: nil, idempotency_key: nil)
      request(
        uri:     "categories/#{category_id}",
        method:  :put,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        },
        payload: {
                   name:               name,
                   parent_category_id: parent_category_id,
                   status_display:     status_display,
                   status_best:        status_best,
                   filter_color:       filter_color,
                   filter_size:        filter_size
                 }.compact
      )
    end

    # 카테고리 삭제 (DELETE /v1/categories/:id)
    # @comment_by Claude (alfred)
    # @date: 26-11-13
    # supervisor 전용
    def category_delete(category_id:, idempotency_key: nil)
      request(
        uri:     "categories/#{category_id}",
        method:  :delete,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        }
      )
    end
  end
end
