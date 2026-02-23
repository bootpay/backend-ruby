module BootpayStore::Concern::Store
  extend ActiveSupport::Concern

  included do
    # 가맹점 기본 정보를 조회한다 (/v1/store)
    # Comment by Codex
    # @date: 2026-02-23
    def store(idempotency_key: nil)
      request(
        uri:     'store',
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid
        }
      )
    end

    # 가맹점 상세 정보를 조회한다 (/v1/store/detail)
    # Comment by Codex
    # @date: 2026-02-23
    def store_detail(idempotency_key: nil)
      request(
        uri:     'store/detail',
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid
        }
      )
    end
  end
end
