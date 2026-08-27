module BootpayStore::Concern::AlimtalkOfficial
  extend ActiveSupport::Concern

  # 부트페이 공식 알림톡 템플릿 카탈로그 — GET/POST /v1/alimtalk/official 계열
  #
  # 부트페이가 미리 카카오 승인을 받아 둔 템플릿이라, 그룹키가 등록된 채널이면 **검수 없이 즉시 발송**된다.
  # `alimtalk_sender_create` 로 채널을 등록하면 그룹 등록이 함께 끝나므로 따로 채택할 것이 없다.
  #
  # 전부 조회 계열이라 부작용이 없다(자체 DB 만 본다).
  # @date: 26-08-27 채택(alimtalk_official_adopt) 제거 — 서버에서도 엔드포인트를 비활성화했다.
  #
  # @comment_by Claude (alfred)
  # @date: 26-08-27
  included do
    # 공식 템플릿을 검색한다 (GET /v1/alimtalk/official)
    # keyword 는 본문·이름·분류를 부분일치(대소문자 무시)로 훑는다.
    # msg_type 은 BA(기본형)·EX(부가정보형)만 존재한다 — 그룹 템플릿이라 AD/MI 는 쓸 수 없다.
    # ksp_id 를 주면 그 채널의 변수 예문 사전으로 variable_examples 를 채워 준다(표시용).
    # 응답: { list: [...], count:, page:, per:, categories: [...] }
    def alimtalk_official_list(keyword: nil, category: nil, msg_type: nil, page: nil, per: nil, ksp_id: nil)
      request(
        uri:     'alimtalk/official',
        method:  :get,
        headers: { 'Bootpay-Role' => 'user' },
        params:  {
          q:        keyword, # 서버는 q 를 먼저 보고 없으면 keyword 를 본다 — 정본 키인 q 로 보낸다
          category: category,
          msg_type: msg_type,
          page:     page,
          per:      per, # 서버 기본 20, 최대 100 으로 clamp
          ksp_id:   ksp_id
        }.compact
      )
    end

    # 보내려는 문구로 공식 템플릿을 추천받는다 (POST /v1/alimtalk/official/recommend)
    # 유사도 score(0~1) 내림차순으로 돌려준다.
    def alimtalk_official_recommend(text:, category: nil, limit: nil, ksp_id: nil)
      request(
        uri:     'alimtalk/official/recommend',
        method:  :post,
        headers: { 'Bootpay-Role' => 'user' },
        payload: {
          text:     text,
          category: category,
          limit:    limit, # 서버 기본 5
          ksp_id:   ksp_id
        }.compact
      )
    end

    # 공식 템플릿 상세를 조회한다 (GET /v1/alimtalk/official/:code)
    # code 는 서버 채번 코드(슬래시를 포함하지 않는다). 없거나 미노출이면 404(3015).
    def alimtalk_official_detail(code:, ksp_id: nil)
      request(
        uri:     "alimtalk/official/#{code}",
        method:  :get,
        headers: { 'Bootpay-Role' => 'user' },
        params:  { ksp_id: ksp_id }.compact
      )
    end
  end
end
