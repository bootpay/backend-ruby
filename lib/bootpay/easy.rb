module Bootpay::Easy
  extend ActiveSupport::Concern

  included do
    # 회원 Token을 요청한다
    # Comment by ehowlsla
    # Date: 2021-08-230

    def get_user_token(user_id: nil, email: nil, name: nil, gender: nil, birth: nil, phone: nil)
      raise 'user_id 값을 입력해주세요.' if user_id.blank?

      request(
        uri: 'request/user/token',
        payload: {
          user_id: user_id, # 개발사에서 관리하는 회원 고유 id
          email: email, # 회원 email
          name: name, # 회원명
          gender: gender, # 0:여자, 1:남자
          birth: birth, # 생일 901004
          phone: phone # 01012341234
        }.compact
      )
    end
  end
end