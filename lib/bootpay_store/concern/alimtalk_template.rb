module BootpayStore::Concern::AlimtalkTemplate
  extend ActiveSupport::Concern

  # 가맹점 자체 알림톡 템플릿 CRUD·등록·검수 — /v1/alimtalk/templates 계열
  #
  # 흐름: (초안 생성 → 확인 → 대행사 등록) → 검수 요청 → 승인(APR) → 발송 가능
  #   `alimtalk_template_create(register: false)` 로 초안만 만들고, 내용을 확인한 뒤
  #   `alimtalk_template_register` 로 올리는 것을 권장한다.
  #
  # ⚠️ `register` 를 명시적으로 false 로 주지 않으면 **생성 즉시 대행사·카카오에 실제 등록**된다.
  # ⚠️ 본문 변수는 `#{변수명}` 형식이고 템플릿 전체에서 최대 40개다.
  #
  # @comment_by Claude (alfred)
  # @date: 26-08-27
  included do
    # 내 자체 템플릿 목록을 조회한다 (GET /v1/alimtalk/templates)
    # ins: 검수상태 필터 — 1 REG(등록) / 2 REQ(검수요청) / 3 APR(승인) / 4 KRR(등록거절) / 5 REJ(승인반려).
    #      숫자·숫자문자열·벤더 문자열('APR' 등)을 모두 받는다. 해석 못 하는 값은 필터 없음으로 떨어진다.
    # keyword: 코드·이름·본문·분류 부분일치. sort: latest(기본)·oldest·code.
    # ⚠️ 페이지네이션이 없다 — 필터에 걸린 템플릿을 한 번에 모두 돌려준다.
    def alimtalk_template_list(ins: nil, sort: nil, keyword: nil)
      request(
        uri:     'alimtalk/templates',
        method:  :get,
        headers: { 'Bootpay-Role' => 'user' },
        params:  {
          ins:     ins,
          sort:    sort,
          keyword: keyword
        }.compact
      )
    end

    # 자체 템플릿을 생성한다 (POST /v1/alimtalk/templates)
    # ⚠️ register 를 false 로 주지 않으면 대행사·카카오에 **실제 등록**된다(되돌리려면 삭제해야 한다).
    #
    # emphasize_type: NONE·TEXT(강조표기형)·IMAGE(이미지형)·ITEM_LIST(아이템리스트형)
    #   - TEXT 는 emphasize_title·emphasize_subtitle 둘 다 필수(각 50자·40자)
    #   - IMAGE 는 이미지 필수 — alimtalk_template_image 로 올린 URL 을 storage_image_url 로 넘긴다
    #   - ITEM_LIST 는 template_item.list(2~10개) 필수 + template_header·item_highlight·이미지 중 하나 이상
    # msg_type: BA(기본형)·EX(부가정보형, template_extra 필수)·AD(채널추가형)·MI(복합형)
    #   - AD·MI 는 채널추가(AC) 버튼이 필수다
    # examples: 변수 예문(표시용). 주면 **모든 변수에 예문이 있어야** 한다(없으면 3017).
    def alimtalk_template_create(ksp_id:, name: nil, content: nil, register: nil, buttons: nil,
                                 msg_type: nil, emphasize_type: nil, emphasize_title: nil,
                                 emphasize_subtitle: nil, template_extra: nil, template_header: nil,
                                 item_highlight: nil, template_item: nil, image_url: nil,
                                 storage_image_url: nil, security_flag: nil, category: nil, tags: nil,
                                 examples: nil, template_code: nil, **attrs)
      request(
        uri:     'alimtalk/templates',
        method:  :post,
        headers: { 'Bootpay-Role' => 'user' },
        payload: {
          ksp_id:             ksp_id,
          register:           register,
          name:               name,
          content:            content,
          buttons:            buttons,
          msg_type:           msg_type,
          emphasize_type:     emphasize_type,
          emphasize_title:    emphasize_title,
          emphasize_subtitle: emphasize_subtitle,
          template_extra:     template_extra,
          template_header:    template_header,
          item_highlight:     item_highlight,
          template_item:      template_item,
          image_url:          image_url,
          storage_image_url:  storage_image_url,
          security_flag:      security_flag,
          category:           category,
          tags:               tags,
          examples:           examples,
          template_code:      template_code
        }.merge(attrs).compact
      )
    end

    # 자체 템플릿 상세를 조회한다 (GET /v1/alimtalk/templates/:id)
    # template_id 는 문서 id 이고, ObjectId 형식이 아니면 **템플릿 코드**로 해석한다.
    # ⚠️ sync 는 서버 기본값이 **true** 라 조회만 해도 벤더 상태 동기화가 일어난다.
    #    초안(등록 전)을 조회할 때는 sync: false 를 권장한다.
    def alimtalk_template_detail(template_id:, sync: nil)
      request(
        uri:     "alimtalk/templates/#{template_id}",
        method:  :get,
        headers: { 'Bootpay-Role' => 'user' },
        params:  { sync: sync }.compact
      )
    end

    # 자체 템플릿을 수정한다 (PUT /v1/alimtalk/templates/:id)
    # ⚠️ **부분 수정이 아니다.** 보내지 않은 필드는 nil 로 덮어써지므로 항상 전체 필드를 보낸다.
    # ⚠️ 등록된 템플릿을 수정하면 벤더에도 수정 요청이 나간다.
    #    수정 가능 상태는 초안 / REG(등록) / REJ(승인반려) / KRR(등록거절) 뿐이다 — APR·REQ 는 거부된다.
    # storage_image_url 을 빈 값으로 보내면 **이미지 삭제**로 처리되어 벤더에도 전달된다.
    def alimtalk_template_update(template_id:, name: nil, content: nil, buttons: nil, msg_type: nil,
                                 emphasize_type: nil, emphasize_title: nil, emphasize_subtitle: nil,
                                 template_extra: nil, template_header: nil, item_highlight: nil,
                                 template_item: nil, image_url: nil, storage_image_url: nil,
                                 security_flag: nil, category: nil, tags: nil, examples: nil,
                                 template_code: nil, **attrs)
      request(
        uri:     "alimtalk/templates/#{template_id}",
        method:  :put,
        headers: { 'Bootpay-Role' => 'user' },
        payload: {
          name:               name,
          content:            content,
          buttons:            buttons,
          msg_type:           msg_type,
          emphasize_type:     emphasize_type,
          emphasize_title:    emphasize_title,
          emphasize_subtitle: emphasize_subtitle,
          template_extra:     template_extra,
          template_header:    template_header,
          item_highlight:     item_highlight,
          template_item:      template_item,
          image_url:          image_url,
          storage_image_url:  storage_image_url,
          security_flag:      security_flag,
          category:           category,
          tags:               tags,
          examples:           examples,
          template_code:      template_code
        }.merge(attrs).compact
      )
    end

    # 자체 템플릿을 삭제한다 (DELETE /v1/alimtalk/templates/:id)
    # 초안(등록 전)은 대행사 거부와 무관하게 로컬에서 삭제된다.
    # ⚠️ 등록분은 **대행사 삭제가 성공해야** 삭제된다 — 승인(APR) 템플릿은 카카오가 거부하므로
    #    500(3013)이 오고 템플릿은 남는다. 같은 코드가 대행사에 선점된 채 로컬만 사라지는 것을 막기 위함이다.
    def alimtalk_template_delete(template_id:)
      request(
        uri:     "alimtalk/templates/#{template_id}",
        method:  :delete,
        headers: { 'Bootpay-Role' => 'user' }
      )
    end

    # 초안을 대행사에 등록한다 (POST /v1/alimtalk/templates/:id/register)
    # ⚠️ 대행사·카카오에 실제 등록된다. 등록 전(초안) 상태에서만 호출할 수 있다.
    def alimtalk_template_register(template_id:)
      request(
        uri:     "alimtalk/templates/#{template_id}/register",
        method:  :post,
        headers: { 'Bootpay-Role' => 'user' }
      )
    end

    # 검수를 요청한다 (POST /v1/alimtalk/templates/:id/inspect)
    # ⚠️ **카카오에 검수를 요청하며 취소할 수 없다.**
    # 대행사 등록이 끝난 대기(R) + REG(등록) 상태에서만 호출할 수 있다 — 초안은 먼저 register 를 부른다.
    # 반려(REJ/KRR)된 건은 재요청이 아니라 **수정 후 재요청**이다. 반려 사유는 응답의 comments 에 담긴다.
    def alimtalk_template_inspect(template_id:)
      request(
        uri:     "alimtalk/templates/#{template_id}/inspect",
        method:  :post,
        headers: { 'Bootpay-Role' => 'user' }
      )
    end

    # 템플릿 목록을 내보낸다 (GET /v1/alimtalk/templates/export)
    # scope: private(기본, 내 채널 자체 템플릿)·official(공식 카탈로그)·all
    # ⚠️ 기본 format 을 **json 으로 둔다** — 서버 기본은 csv 지만, csv 본문은 JSON 이 아니라서
    #    공용 request 의 파싱을 통과하지 못한다. csv 를 주면 파싱 없이 원문 문자열을 담아 돌려준다.
    # 1회 5,000건을 넘으면 3031 로 거부되므로 채널·상태 필터로 좁힌다.
    def alimtalk_template_export(format: 'json', scope: nil, ksp_id: nil, status: nil, include_content: nil)
      params = {
        format:          format,
        scope:           scope,
        ksp_id:          ksp_id,
        status:          status,
        include_content: include_content
      }.compact

      return request_raw(uri: 'alimtalk/templates/export', params: params,
                         headers: { 'Bootpay-Role' => 'user' }) if format.to_s == 'csv'

      request(
        uri:     'alimtalk/templates/export',
        method:  :get,
        headers: { 'Bootpay-Role' => 'user' },
        params:  params
      )
    end

    # 이미지형 템플릿의 원본 이미지를 올린다 (POST /v1/alimtalk/templates/image)
    # 돌려받은 image_url 을 템플릿 생성/수정의 storage_image_url 로 넘긴다.
    # 규격을 업로드 **전에** 서버가 검사한다 — jpg/png · 500KB 이하 · 가로 500px 이상 · 2:1.
    # image 는 파일 경로(String)·IO·HTTP::FormData::File 을 모두 받는다.
    # replace_url 을 주면 업로드 성공 후에 기존 파일을 지운다.
    def alimtalk_template_image(image:, replace_url: nil)
      form = { 'image' => multipart_file(image) }
      form['replace_url'] = multipart_value(replace_url) if replace_url.present?

      post_multipart(uri: 'alimtalk/templates/image', form: form,
                     headers: { 'Bootpay-Role' => 'user' })
    end

    # 아이템리스트형의 하이라이트 썸네일을 올린다 (POST /v1/alimtalk/templates/highlight_image)
    # ⚠️ 본문 이미지와 **규격이 다르다** — jpg/png · 500KB 이하 · 가로 **108px** 이상 · **1:1**.
    #    본문 이미지 엔드포인트로 올리면 거부된다.
    # 돌려받은 image_url 은 item_highlight.storage_image_url 로 넘긴다.
    # ⚠️ 썸네일을 붙이면 하이라이트 글자 한도가 줄어든다(타이틀 30→21, 설명 19→13).
    def alimtalk_template_highlight_image(image:, replace_url: nil)
      form = { 'image' => multipart_file(image) }
      form['replace_url'] = multipart_value(replace_url) if replace_url.present?

      post_multipart(uri: 'alimtalk/templates/highlight_image', form: form,
                     headers: { 'Bootpay-Role' => 'user' })
    end
  end
end
