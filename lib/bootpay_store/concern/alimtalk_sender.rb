module BootpayStore::Concern::AlimtalkSender
  extend ActiveSupport::Concern

  # 알림톡 발신프로필(카카오채널) 생명주기 — GET /v1/alimtalk/categories · /senders 계열
  #
  # 카테고리 조회 → OTP 발송 → 발신프로필 등록 → 목록/상세 → 연동 해지 순으로 쓴다.
  # 등록이 끝나면 서버가 그룹키 등록까지 자동으로 하므로, 공식 템플릿은 별도 채택 없이 바로 발송된다.
  #
  # ⚠️ 실제 부작용: `alimtalk_sender_otp` 는 채널 관리자 휴대폰으로 **문자를 실제 발송**하고,
  #    `alimtalk_sender_create` 는 카카오에 발신프로필을 **실제 등록**한다. 샌드박스가 없다.
  #
  # ★Idempotency-Key 를 싣지 않는다★ 알림톡 API 는 이 헤더를 읽지 않는다(멱등은 발송의 ref_id 로만 성립).
  #   invoice/product 처럼 무조건 붙이면 서버가 주지 않는 보장을 주는 것처럼 보인다.
  # ★Bootpay-Role 은 항상 user★ 알림톡 스코프 키가 전부 `user:alimtalk_*` 다.
  #
  # @comment_by Claude (alfred)
  # @date: 26-08-27
  included do
    # 카카오 카테고리 목록을 조회한다 (GET /v1/alimtalk/categories)
    # 발신프로필 등록 시 필요한 category_code 후보다. 벤더 응답을 그대로 프록시한다.
    def alimtalk_categories
      request(
        uri:     'alimtalk/categories',
        method:  :get,
        headers: { 'Bootpay-Role' => 'user' }
      )
    end

    # 채널 관리자폰으로 OTP 를 발송한다 (POST /v1/alimtalk/senders/otp)
    # ⚠️ 실제로 문자가 나간다. 여기서 받은 인증번호를 alimtalk_sender_create 의 otp 로 넘긴다.
    def alimtalk_sender_otp(yellow_id:, phone:)
      request(
        uri:     'alimtalk/senders/otp',
        method:  :post,
        headers: { 'Bootpay-Role' => 'user' },
        payload: {
          yellow_id: yellow_id,
          phone:     phone
        }.compact
      )
    end

    # 발신프로필을 등록한다 (POST /v1/alimtalk/senders)
    # ⚠️ 카카오에 발신프로필이 실제 등록된다. 같은 yellow_id 를 다시 등록하면 기존 프로필을 재사용한다(dedup).
    # 등록 성공 시 그룹키 등록까지 서버가 수행하므로 공식 카탈로그 전체를 바로 발송할 수 있다.
    def alimtalk_sender_create(otp:, yellow_id:, phone:, category_code:)
      request(
        uri:     'alimtalk/senders',
        method:  :post,
        headers: { 'Bootpay-Role' => 'user' },
        payload: {
          otp:           otp,
          yellow_id:     yellow_id,
          phone:         phone,
          category_code: category_code
        }.compact
      )
    end

    # 연동한 채널 목록을 조회한다 (GET /v1/alimtalk/senders)
    # 자체 DB 만 조회하며 벤더를 호출하지 않는다. 응답은 { list: [...], count: N }.
    def alimtalk_sender_list
      request(
        uri:     'alimtalk/senders',
        method:  :get,
        headers: { 'Bootpay-Role' => 'user' }
      )
    end

    # 채널 상세를 조회한다 (GET /v1/alimtalk/senders/:id)
    # sync: true 면 벤더에서 채널 상태를 다시 읽어 반영한다(느리다). 미지정이면 자체 DB 만 본다.
    # ⚠️ 미연동/미존재 채널은 404, 다른 프로젝트의 채널은 403 으로 오며 둘 다 error_code 는 3024 다.
    def alimtalk_sender_detail(ksp_id:, sync: nil)
      request(
        uri:     "alimtalk/senders/#{ksp_id}",
        method:  :get,
        headers: { 'Bootpay-Role' => 'user' },
        params:  { sync: sync }.compact
      )
    end

    # 채널 연동을 해지한다 (DELETE /v1/alimtalk/senders/:id)
    # 이 프로젝트와의 연동만 끊는다 — 채널 모델과 템플릿은 보존된다. 성공 시 본문은 null 이다.
    def alimtalk_sender_release(ksp_id:)
      request(
        uri:     "alimtalk/senders/#{ksp_id}",
        method:  :delete,
        headers: { 'Bootpay-Role' => 'user' }
      )
    end

    # 채널 변수 예문 사전을 갱신한다 (PUT /v1/alimtalk/senders/:id/variable_examples)
    # 템플릿 미리보기에서 #{user_name} 대신 '홍길동' 처럼 읽히게 하는 **표시용** 값이다.
    # ⚠️ 발송값이 아니다 — 벤더로 전송되지 않으므로 검수 상태와 무관하다. 보낸 키만 덮어쓴다(부분 갱신).
    # examples: { user_name: '홍길동', company_name: '부트페이몰' } — 키에 '.' 이나 선행 '$' 는 쓸 수 없다.
    def alimtalk_sender_variable_examples(ksp_id:, examples:)
      request(
        uri:     "alimtalk/senders/#{ksp_id}/variable_examples",
        method:  :put,
        headers: { 'Bootpay-Role' => 'user' },
        payload: { examples: examples }.compact
      )
    end
  end
end
