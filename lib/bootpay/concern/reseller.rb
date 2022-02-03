module Bootpay::Concern::Reseller
  extend ActiveSupport::Concern

  included do
    # 가맹점 계정을 생성한다
    # Comment by Gosomi
    # Date: 2022-01-05
    def create_seller(company_alias:, company_name:, email: nil, regist_no: nil, owner_name: nil,
                      phone: nil, zip: nil, address1: nil, address2: nil)
      request(
        uri:     'reseller/seller',
        payload: {
          company_alias: company_alias,
          company_name:  company_name,
          email:         email,
          regist_no:     regist_no,
          owner_name:    owner_name,
          phone:         phone,
          zip:           zip,
          address1:      address1,
          address2:      address2
        }
      )
    end

    # 판매점의 프로젝트 생성하기
    # Comment by Gosomi
    # Date: 2022-01-05
    def create_seller_app(provider_id:, name:, unit: 'KRW', real: '실물', desc: nil, timezone: 'Asia/Seoul')
      request(
        uri:     'reseller/seller/app',
        payload: {
          provider_id: provider_id,
          name:        name,
          unit:        unit,
          real:        real,
          desc:        desc,
          timezone:    timezone
        }
      )
    end

    # 프로젝트/가맹점 초대하기
    # Comment by Gosomi
    # Date: 2022-01-13
    def member_invite(email:, level:, app_id: nil, invite_type:, provider_id: nil)
      request(
        uri:     'reseller/invite',
        payload: {
          email:       email,
          level:       level,
          app_id:      app_id,
          provider_id: provider_id,
          invite_type: invite_type
        }
      )
    end
  end
end