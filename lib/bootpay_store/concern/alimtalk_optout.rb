module BootpayStore::Concern::AlimtalkOptout
  extend ActiveSupport::Concern

  # 알림톡 수신거부 — /v1/alimtalk/optouts 계열 (가맹점 CRM 수신거부 동기화용)
  #
  # 발송 판정과 **같은 기준**으로 다룬다 — 부트페이 전역(global) + 내 프로젝트.
  # ⚠️ 전역 건은 **조회는 되지만 해제할 수 없다**(releasable: false).
  #    이걸 노출하지 않으면 "화면엔 수신거부가 아닌데 발송은 3021 로 막히는" 상태가 된다.
  #
  # @comment_by Claude (alfred)
  # @date: 26-08-27
  included do
    # 수신거부 목록을 조회한다 (GET /v1/alimtalk/optouts)
    # phone 은 숫자만 남겨 **부분일치**로 찾는다(정확 매칭이 아니다). 50건 단위로 페이징된다.
    # 응답: { list: [{ id:, phone:, scope:, global:, releasable:, source:, reason:, opted_out_at:, created_at: }],
    #        count:, page: }
    def alimtalk_optout_list(phone: nil, page: nil)
      request(
        uri:     'alimtalk/optouts',
        method:  :get,
        headers: { 'Bootpay-Role' => 'user' },
        params:  {
          phone: phone,
          page:  page
        }.compact
      )
    end

    # 수신거부를 등록한다 (POST /v1/alimtalk/optouts)
    # 내 프로젝트 스코프로 등록된다(source: api). 같은 번호를 다시 등록해도 멱등이다.
    def alimtalk_optout_create(phone:, reason: nil)
      request(
        uri:     'alimtalk/optouts',
        method:  :post,
        headers: { 'Bootpay-Role' => 'user' },
        payload: {
          phone:  phone,
          reason: reason
        }.compact
      )
    end

    # 발송 전에 수신거부를 사전 확인한다 (POST /v1/alimtalk/optouts/check)
    # 발송 판정과 **같은 축**으로 대조하므로, 벌크에서 skipped 로 낭비될 건을 미리 뺄 수 있다.
    # 단건(phone)·다건(phones) 모두 받는다. ⚠️ 1회 최대 1,000건이고 넘으면 -48 이다(중복은 서버가 제거).
    # 응답: { list: [{ phone:, opted_out:, global:, releasable:, opted_out_at: }], count:, opted_out_count: }
    def alimtalk_optout_check(phones: nil, phone: nil)
      request(
        uri:     'alimtalk/optouts/check',
        method:  :post,
        headers: { 'Bootpay-Role' => 'user' },
        payload: {
          phones: phones,
          phone:  phone
        }.compact
      )
    end

    # 수신거부를 해제한다 (DELETE /v1/alimtalk/optouts/:phone)
    # 내 프로젝트 스코프 건만 해제되며 멱등이다(없어도 성공).
    # ⚠️ 전역 차단은 해제되지 않고 global_blocked: true 로 알려 준다 —
    #    "지웠는데 여전히 막히는" 상태를 응답으로 드러내기 위함이다.
    # 응답: { phone:, released:, global_blocked: }
    def alimtalk_optout_release(phone:)
      request(
        uri:     "alimtalk/optouts/#{phone}",
        method:  :delete,
        headers: { 'Bootpay-Role' => 'user' }
      )
    end
  end
end
