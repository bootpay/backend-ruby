module BootpayStore::Concern::AlimtalkWebhook
  extend ActiveSupport::Concern

  # 알림톡 발송결과·검수결과 웹훅 설정 — /v1/alimtalk/webhook 계열
  #
  # ⚠️ **주문·구독 통합 웹훅과 완전히 별개다.** 알림톡 이벤트를 기존 주문 웹훅 URL 로 태우면
  #    그 수신 서버가 모르는 payload 를 받아 기존 연동이 깨진다. 그래서 수신 URL 을 따로 둔다.
  #    (`send_test_webhook` 은 주문 웹훅용이다 — 이 파일의 `alimtalk_webhook_test` 와 혼동하지 말 것)
  #
  # ## 서명 검증
  # 요청에 다음 헤더가 붙는다.
  #   X-Bootpay-Signature: sha256=HMAC_SHA256(secret, "{X-Bootpay-Timestamp}.{raw_body}")
  # 타임스탬프가 5분 이상 지난 요청은 거부한다(replay 방지).
  #
  # @comment_by Claude (alfred)
  # @date: 26-08-27
  included do
    # 웹훅 설정을 조회한다 (GET /v1/alimtalk/webhook)
    # 시크릿은 앞 12자만 노출된다. 미설정이면 { configured: false } 로 온다.
    def alimtalk_webhook_detail
      request(
        uri:     'alimtalk/webhook',
        method:  :get,
        headers: { 'Bootpay-Role' => 'user' }
      )
    end

    # 웹훅 설정을 저장한다 (PUT /v1/alimtalk/webhook)
    # url 은 **https 만** 허용한다(아니면 3028). 최초 저장 시 서명 시크릿이 자동 발급된다.
    # events: 구독할 이벤트 코드. 목록에 없는 값은 저장 시 조용히 버려진다(유령 구독 방지).
    #   300 발송 접수(기본 미구독) / 301 전달 성공 / 302 전달 실패 / 303 예약 취소 /
    #   304 문자(LMS) 대체발송 전환 / 310 검수 승인 / 311 검수 반려 / 320 수신거부 등록(기본 미구독)
    # events 를 비우면 기본 구독셋(301·302·303·304·310·311)이 적용된다.
    def alimtalk_webhook_update(url: nil, events: nil, enabled: nil)
      request(
        uri:     'alimtalk/webhook',
        method:  :put,
        headers: { 'Bootpay-Role' => 'user' },
        payload: {
          url:     url,
          events:  events,
          enabled: enabled
        }.compact
      )
    end

    # 테스트 이벤트를 1건 발송한다 (POST /v1/alimtalk/webhook/test)
    # ⚠️ **설정된 URL 로 실제 HTTP 요청이 나간다.** 구독 여부와 무관하게 보낸다.
    # 웹훅이 설정돼 있지 않으면 3029. 응답: { delivery_id:, url:, queued: }
    def alimtalk_webhook_test
      request(
        uri:     'alimtalk/webhook/test',
        method:  :post,
        headers: { 'Bootpay-Role' => 'user' }
      )
    end

    # 서명 시크릿을 재발급한다 (POST /v1/alimtalk/webhook/secret)
    # ⚠️ **이 응답에서만 secret 원문을 돌려준다**(이후 조회는 마스킹된다).
    # ⚠️ 이미 큐에 있는 전송 건은 발송 당시 시크릿으로 서명된다.
    def alimtalk_webhook_rotate_secret
      request(
        uri:     'alimtalk/webhook/secret',
        method:  :post,
        headers: { 'Bootpay-Role' => 'user' }
      )
    end

    # 웹훅 전송 이력을 조회한다 (GET /v1/alimtalk/webhook/deliveries)
    # 성공·실패를 모두 남긴다. 응답: { list: [{ delivery_id:, event:, event_code:, url:, status:,
    #   retry_count:, max_retry:, tags:, created_at: }], count:, page:, per: }
    def alimtalk_webhook_deliveries(page: nil, limit: nil)
      request(
        uri:     'alimtalk/webhook/deliveries',
        method:  :get,
        headers: { 'Bootpay-Role' => 'user' },
        params:  {
          page:  page,
          limit: limit # 서버 기본 20, 최대 100
        }.compact
      )
    end
  end
end
