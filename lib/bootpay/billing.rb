module Bootpay::Billing
  extend ActiveSupport::Concern

  included do
    # 빌링키 가져오기
    # Comment by ehowlsla
    # Date: 2021-08-30
    def get_billing_key(order_id: nil, pg: nil, item_name: nil, card_no: nil, card_pw: nil, expire_year: nil, expire_month: nil, identify_number: nil,
                       user_info: { # 구매자 정보
                         id: nil, #  개발사에서 관리하는 회원 고유 id
                         username: nil, # 구매자 이름
                         email: nil, # 구매자 email
                         phone: nil, # 01012341234
                         gender: nil, # 0:여자, 1:남자
                         area: nil, # 서울|인천|대구|광주|부산|울산|경기|강원|충청북도|충북|충청남도|충남|전라북도|전북|전라남도|전남|경상북도|경북|경상남도|경남|제주|세종|대전 중 택 1
                         birth: nil # 생일 901004
                       },
                       extra: { # 기타 설정
                         subscribe_test_payment: nil, # subscribe_test_payment:100원 결제 후 결제가 되면 billing key를 발행, 결제가 실패하면 에러
                         raw_data: nil # raw_data: PG 오류 코드 및 메세지까지 리턴
                       })
      request(
        uri: 'request/card_rebill',
        payload:
          {
            order_id:        order_id, # 개발사에서 관리하는 고유 주문 번호
            pg:              pg, # PG사의 Alias ex) danal, kcp, inicis 등
            item_name:       item_name, # 상품명
            card_no:         card_no, # 카드 일련번호
            card_pw:         card_pw, # 카드 비밀번호 앞 2자리
            expire_year:     expire_year, # 카드 유효기간 년
            expire_month:    expire_month, # 카드 유효기간 월
            identify_number: identify_number, # 주민등록번호 또는 사업자번호
            user_info:       user_info, # 구매자 정보
            extra:           extra.values.any? {|v|v != nil} ? extra : nil
          }.compact
      )
    end

    # 빌링키 삭제하기
    # Comment by ehowlsla
    # Date: 2021-08-30
    def destroy_billing_key(billing_key)
      request(
        method: :delete,
        uri: "subscribe/billing/#{billing_key}"
      )
    end

    # 빌링키로 결제 요청하기
    # Comment by ehowlsla
    # Date: 2021-08-30
    def subscribe_billing(billing_key: nil, item_name: nil, price: 0, tax_free: 0, order_id: nil, quota: nil, interest: nil,
                          user_info: { # 구매자 정보
                                       id: nil, #  개발사에서 관리하는 회원 고유 id
                                       username: nil, # 구매자 이름
                                       email: nil, # 구매자 email
                                       phone: nil, # 01012341234
                                       gender: nil, # 0:여자, 1:남자
                                       area: nil, # 서울|인천|대구|광주|부산|울산|경기|강원|충청북도|충북|충청남도|충남|전라북도|전북|전라남도|전남|경상북도|경북|경상남도|경남|제주|세종|대전 중 택 1
                                       birth: nil # 생일 901004
                          },
                          feedback_url: nil, feedback_content_type: nil,
                          extra: { # 기타 설정
                                   subscribe_test_payment: nil, # subscribe_test_payment:100원 결제 후 결제가 되면 billing key를 발행, 결제가 실패하면 에러
                                   raw_data: nil # raw_data: PG 오류 코드 및 메세지까지 리턴
                          })
      raise 'billing_key 값을 입력해주세요.' if billing_key.blank?
      raise 'item_name 값을 입력해주세요.' if item_name.blank?
      raise 'price 금액을 설정을 해주세요.' if price.blank?
      raise 'order_id 주문번호를 설정해주세요.' if order_id.blank?
      request(
        uri: 'subscribe/billing',
        payload: {
          billing_key:    billing_key, # 발급받은 빌링키
          item_name:      item_name, # 결제할 상품명, 결제창에 노출됨
          price:          price, # 결제할 상품금액
          tax_free:       tax_free, # 면세 상품일 경우 해당만큼의 금액을 설정
          order_id:       order_id, # 개발사에서 지정하는 고유주문번호
          quota:          quota, # 5만원 이상 결제건에 적용하는 할부개월수. 0-일시불, 1은 지정시 에러 발생함, 2-2개월, 3-3개월... 12까지 지정가능
          interest:       interest, # 웰컴페이먼츠 전용, 무이자여부를 보내는 파라미터가 있다
          user_info:      user_info.values.any? {|v|v != nil} ? user_info : nil,
          feedback_url:   feedback_url, # webhook 통지시 받으실 url 주소 (localhost 사용 불가)
          feedback_content_type: feedback_content_type.presence || 'urlencoded', # webhook 통지시 받으실 데이터 타입 (json 또는 urlencoded, 기본값 urlencoded)
          extra:          extra.values.any? {|v|v != nil} ? extra : nil # subscribe_test_payment:100원 결제 후 결제가 되면 billing key를 발행, 결제가 실패하면 에러, raw_data: PG 오류 코드 및 메세지까지 리턴
        }.compact,
      )
    end

    # 빌링키로 결제 예약하기
    # Comment by ehowlsla
    # Date: 2021-08-30
    def subscribe_reserve_billing(billing_key: nil, item_name: nil, price: 0, tax_free: 0, order_id: nil, quota: 12, interest: 0,
                          user_info: {id: nil, username: nil, email: nil, phone: nil, gender: nil, area: nil, birth: nil},
                          feedback_url: nil, feedback_content_type: nil,
                          extra: {subscribeTestPayment: 0, raw_data: 0},
                          execute_at: nil)
      raise 'billing_key 값을 입력해주세요.' if billing_key.blank?
      raise 'item_name 값을 입력해주세요.' if item_name.blank?
      raise 'price 금액을 설정을 해주세요.' if price.blank?
      raise 'order_id 주문번호를 설정해주세요.' if order_id.blank?
      request(
        uri: 'subscribe/billing/reserve',
        payload: {
          billing_key:    billing_key, # 발급받은 빌링키
          item_name:      item_name, # 결제할 상품명, 결제창에 노출됨
          price:          price, # 결제할 상품금액
          tax_free:       tax_free, # 면세 상품일 경우 해당만큼의 금액을 설정
          order_id:       order_id, # 개발사에서 지정하는 고유주문번호
          quota:          quota, # 5만원 이상 결제건에 대한 할부개월 노출 설정. 00-일시불, 01-1개월, 02-2개월 ... 12까지 지정가능, 만약 09로 지정할 경우 최대 9개월까지 선택가능. 지정하지 않을 경우 해당 PG사의 기본값 적용
          interest:       interest, # 웰컴페이먼츠 전용, 무이자여부를 보내는 파라미터가 있다
          user_info:      user_info.values.any? {|v|v != nil} ? user_info : nil,
          feedback_url:   feedback_url,  # webhook 통지시 받으실 url 주소 (localhost 사용 불가)
          feedback_content_type: feedback_content_type.presence || 'urlencoded', # webhook 통지시 받으실 데이터 타입 (json 또는 urlencoded, 기본값 urlencoded)
          extra:          extra.values.any? {|v|v != nil} ? extra : nil, # subscribe_test_payment:100원 결제 후 결제가 되면 billing key를 발행, 결제가 실패하면 에러, raw_data: PG 오류 코드 및 메세지까지 리턴
          scheduler_type: 'oneshot',
          execute_at:     execute_at.presence || (Time.now + 10.seconds).to_i # 예약 실행시간, 미지정 시 10초뒤 실행
        }.compact,
        )
    end

    # 결제 예약 취소하기
    # Comment by ehowlsla
    # Date: 2021-08-30
    def subscribe_reserve_cancel(reserve_id)
      raise 'reserve_id를 입력해주세요.' if reserve_id.blank?
      request(
        method: :delete,
        uri: "subscribe/billing/reserve/#{reserve_id}"
      )
    end
  end
end