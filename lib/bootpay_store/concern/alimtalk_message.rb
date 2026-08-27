module BootpayStore::Concern::AlimtalkMessage
  extend ActiveSupport::Concern

  # 알림톡 발송내역·집계 — GET /v1/alimtalk/messages 계열
  #
  # **유료** 알림톡만 조회된다(무료 커머스 알림톡은 포함되지 않는다).
  # 상태는 벤더 결과 동기화로 확정되므로 접수 직후에는 requested 로 보인다.
  #
  # @comment_by Claude (alfred)
  # @date: 26-08-27
  included do
    # 발송내역 목록을 조회한다 (GET /v1/alimtalk/messages)
    # status: requested·success·failed·canceled
    # to: 수신번호(하이픈 무관, 정확 매칭) / ref_id: 발송 시 넘긴 멱등키
    # ⚠️ 기간 기본값은 최근 30일이고 최대 조회 폭은 92일이다 — 초과분은 거부하지 않고 시작일을 당겨 잘라낸다.
    #    실제 적용된 구간은 응답의 period 로 확인한다.
    # 응답: { list: [...], count:, page:, per:, period: { from:, to: } }
    def alimtalk_message_list(template_code: nil, status: nil, ref_id: nil, to: nil,
                              s_at: nil, e_at: nil, page: nil, limit: nil)
      request(
        uri:     'alimtalk/messages',
        method:  :get,
        headers: { 'Bootpay-Role' => 'user' },
        params:  {
          template_code: template_code,
          status:        status,
          ref_id:        ref_id,
          to:            to,
          s_at:          s_at,
          e_at:          e_at,
          page:          page,
          limit:         limit # 서버 기본 20, 최대 100
        }.compact
      )
    end

    # 기간 집계를 조회한다 (GET /v1/alimtalk/messages/stats)
    # 일자별 집계 원장에서 읽으므로 응답이 빠르다.
    # 응답: { period:, totals: { sent, success, failed, fallback, opted_out_hit, rejected, canceled, success_rate },
    #        daily: [...], billing: { billable_count, unit_price, fallback_count, ..., amount } }
    # ⚠️ billing.unit_price_source 가 'default' 면 **잠정 단가**다(확정 청구액이 아니다).
    # ⚠️ billable_count 는 성공 − 폴백이다 — 폴백분은 LMS 단가로 따로 계산된다.
    def alimtalk_message_stats(s_at: nil, e_at: nil)
      request(
        uri:     'alimtalk/messages/stats',
        method:  :get,
        headers: { 'Bootpay-Role' => 'user' },
        params:  {
          s_at: s_at,
          e_at: e_at
        }.compact
      )
    end

    # 단건 발송 결과를 조회한다 (GET /v1/alimtalk/messages/:receipt_id)
    # 실패 사유는 error_code·error_message 에 담긴다.
    # fallback_type 은 폴백이 꺼진 건이면 null, 켜진 건이면 LMS 다.
    # 다른 프로젝트의 건이거나 없으면 404(3025).
    def alimtalk_message_detail(receipt_id:)
      request(
        uri:     "alimtalk/messages/#{receipt_id}",
        method:  :get,
        headers: { 'Bootpay-Role' => 'user' }
      )
    end
  end
end
