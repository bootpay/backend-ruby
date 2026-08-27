module BootpayStore::Concern::AlimtalkSend
  extend ActiveSupport::Concern

  # 알림톡 발송 — POST /v1/alimtalk/send · /send/bulk · DELETE /send/:receipt_id
  #
  # ⚠️ **실제로 카카오톡이 발송되고 과금된다. 샌드박스가 없다.**
  #
  # 처리 순서: 멱등 확인 → 템플릿·채널 해석 → 발송권한 → 지갑 자격 → 발송제어 → 폴백 확정(발신번호 확보)
  #   → 수신거부 대조 → 변수 치환·규격검증 → 접수(READY) → 워커 전송
  #
  # - **멱등**: 같은 (프로젝트, ref_id) 로 재요청하면 기존 receipt 를 그대로 돌려준다. 실패한 건만 재발송된다.
  # - **필수 변수**: 템플릿 응답의 required_variables 를 모두 채워야 한다. 하나라도 비면 3017 로 거부된다.
  #   ⚠️ 다만 실제로 치환되어 나가는 건 본문·강조 타이틀·버튼 링크뿐이다 — 보조문구와 아이템리스트형
  #   요소는 발송 페이로드에 자리가 없어 카카오가 등록된 템플릿 문구 그대로 렌더한다.
  # - **채널**: sender_key(공개키)로 지정한다. 생략하면 프로젝트 연동 채널로 해석하며,
  #   연동 채널이 둘 이상일 때만 필수다(ksp_id 는 내부 문서 id 라 발송 API 에 쓰지 않는다).
  #
  # @comment_by Claude (alfred)
  # @date: 26-08-27
  included do
    # 단건 발송 (POST /v1/alimtalk/send)
    # variables: { company_name: '부트페이몰', user_name: '홍길동' } 형태의 치환값
    # ref_id: 가맹점 발송 식별자 — **멱등 키**로 쓰인다
    # reserved_at: 예약 발송 시각(ISO8601). 생략하면 즉시 발송
    # fallback: 알림톡 실패 시 문자(LMS) 대체발송 여부.
    #   ⚠️ **미지정(nil)과 false 는 다르다** — nil 이면 프로젝트 기본값을 따르고, false 는 명시적으로 끈다.
    #   켜면 발신번호가 등록돼 있어야 하며 없으면 3030 으로 거부된다. 대체 문자에는 수신거부 링크가 자동 포함된다.
    # 응답: { receipt_id:, ref_id:, to:, status: } — 접수 직후 status 는 requested
    def alimtalk_send(template_code:, to:, variables: nil, ref_id: nil, fallback: nil,
                      reserved_at: nil, sender_key: nil, user_id: nil)
      request(
        uri:     'alimtalk/send',
        method:  :post,
        headers: { 'Bootpay-Role' => 'user' },
        payload: {
          template_code: template_code,
          to:            to,
          variables:     variables,
          ref_id:        ref_id,
          fallback:      fallback, # compact 은 nil 만 걷어내므로 false 는 그대로 전달된다
          reserved_at:   reserved_at,
          sender_key:    sender_key,
          user_id:       user_id
        }.compact
      )
    end

    # 벌크 발송 (POST /v1/alimtalk/send/bulk) — 1요청 = N수신자
    # recipients: [{ to: '01012345678', ref_id: 'bulk-0001', variables: { ... } }, ...]
    # ⚠️ 수신자 수만큼 실제 발송되고 과금된다.
    # - 쿼터를 넘으면 요청 시점에 **전체 거부**된다(3022) — 일부만 나가지 않는다.
    # - 개별 수신자의 실패는 건별 rejected 로 표시되고 나머지는 정상 발송된다.
    # - 수신거부 번호는 skipped 이며 **과금되지 않고 발송 기록도 만들지 않는다**.
    # - fallback 은 요청 단위로 한 번만 판정한다 — 발신번호가 없으면 요청 전체가 3030 으로 거부된다.
    # 응답: { count:, requested:, skipped:, rejected:, receipts: [...] }
    def alimtalk_send_bulk(template_code:, recipients:, fallback: nil, reserved_at: nil,
                           sender_key: nil, user_id: nil)
      request(
        uri:     'alimtalk/send/bulk',
        method:  :post,
        headers: { 'Bootpay-Role' => 'user' },
        payload: {
          template_code: template_code,
          recipients:    recipients,
          fallback:      fallback,
          reserved_at:   reserved_at,
          sender_key:    sender_key,
          user_id:       user_id
        }.compact
      )
    end

    # 예약 발송을 취소한다 (DELETE /v1/alimtalk/send/:receipt_id)
    # 접수(READY) 상태의 예약 건만 취소할 수 있다 — 이미 전송에 들어갔으면 3023 이다.
    def alimtalk_send_cancel(receipt_id:)
      request(
        uri:     "alimtalk/send/#{receipt_id}",
        method:  :delete,
        headers: { 'Bootpay-Role' => 'user' }
      )
    end
  end
end
