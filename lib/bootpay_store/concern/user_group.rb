module BootpayStore::Concern::UserGroup
  extend ActiveSupport::Concern

  included do
    # 등록된 User Group 정보를 가져온다
    # Comment by GOSOMI
    # @date: 2025-06-18
    def user_groups(keyword: nil, page: 1, limit: 20, corporate_type: 2, idempotency_key: nil)
      request(
        uri:     'user-groups',
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        params:
                 {
                   keyword:        keyword,
                   page:           page,
                   limit:          limit,
                   corporate_type: corporate_type
                 }.compact
      )
    end

    # user group 정보를 가져온다
    # Comment by GOSOMI
    # @date: 2025-06-18
    def lookup_user_group(user_group_id:, idempotency_key: nil)
      request(
        uri:     "user-groups/#{user_group_id}",
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        }
      )
    end

    # 새로운 User Group을 생성한다
    # Comment by GOSOMI
    # @date: 2025-06-18
    def create_user_group(uid: nil, phone: nil, email: nil, address: nil, address_detail: nil, zipcode: nil,
                          corporate_type: nil, bank: nil, bank_code: nil, company_name: nil, business_number: nil,
                          registration_number: nil, business_type: nil, business_category: nil, ceo_name: nil, auth_company: nil,
                          manager_name: nil, manager_phone: nil, manager_email: nil, pccc: nil, use_subscription_aggregate_transaction: nil,
                          subscription_month_day: nil, subscription_week_day: nil, purchase_limit: nil, subscribed_limit: nil,
                          limit_message: nil, idempotency_key: nil)
      request(
        uri:     'user-groups',
        method:  :post,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        payload:
                 {
                   uid:                                    uid,
                   phone:                                  phone,
                   email:                                  email,
                   address:                                address,
                   address_detail:                         address_detail,
                   corporate_type:                         corporate_type,
                   bank:                                   bank,
                   bank_code:                              bank_code,
                   zipcode:                                zipcode,
                   company_name:                           company_name,
                   business_number:                        business_number,
                   registration_number:                    registration_number,
                   business_type:                          business_type,
                   business_category:                      business_category,
                   ceo_name:                               ceo_name,
                   auth_company:                           auth_company,
                   manager_name:                           manager_name,
                   manager_phone:                          manager_phone,
                   manager_email:                          manager_email,
                   pccc:                                   pccc,
                   use_subscription_aggregate_transaction: use_subscription_aggregate_transaction,
                   subscription_month_day:                 subscription_month_day,
                   subscription_week_day:                  subscription_week_day,
                   purchase_limit:                         purchase_limit,
                   subscribed_limit:                       subscribed_limit,
                   limit_message:                          limit_message
                 }.compact
      )
    end

    # UserGroup 정보를 갱신한다
    # Comment by GOSOMI
    # @date: 2025-06-18
    def update_user_group(user_group_id:, phone: nil, email: nil, address: nil, address_detail: nil, zipcode: nil,
                          corporate_type: nil, bank: nil, bank_code: nil, company_name: nil, business_number: nil,
                          registration_number: nil, business_type: nil, business_category: nil, ceo_name: nil, auth_company: nil,
                          manager_name: nil, manager_phone: nil, manager_email: nil, pccc: nil, use_subscription_aggregate_transaction: nil,
                          subscription_month_day: nil, subscription_week_day: nil, purchase_limit: nil, subscribed_limit: nil,
                          limit_message: nil, idempotency_key: nil)
      request(
        uri:     "user-groups/#{user_group_id}",
        method:  :put,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        payload:
                 {
                   phone:                                  phone,
                   email:                                  email,
                   address:                                address,
                   address_detail:                         address_detail,
                   corporate_type:                         corporate_type,
                   bank:                                   bank,
                   bank_code:                              bank_code,
                   zipcode:                                zipcode,
                   company_name:                           company_name,
                   business_number:                        business_number,
                   registration_number:                    registration_number,
                   business_type:                          business_type,
                   business_category:                      business_category,
                   ceo_name:                               ceo_name,
                   auth_company:                           auth_company,
                   manager_name:                           manager_name,
                   manager_phone:                          manager_phone,
                   manager_email:                          manager_email,
                   pccc:                                   pccc,
                   use_subscription_aggregate_transaction: use_subscription_aggregate_transaction,
                   subscription_month_day:                 subscription_month_day,
                   subscription_week_day:                  subscription_week_day,
                   purchase_limit:                         purchase_limit,
                   subscribed_limit:                       subscribed_limit,
                   limit_message:                          limit_message
                 }.compact
      )
    end

    # UserGroup 정보를 삭제한다
    # Comment by GOSOMI
    # @date: 2025-06-19
    def delete_user_group(user_group_id:, idempotency_key: nil)
      request(
        uri:     "user-groups/#{user_group_id}",
        method:  :delete,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        }
      )
    end

    # 사용자 그룹에 사용자를 추가한다
    def add_user_to_group(user_group_id:, user_id:, idempotency_key: nil)
      request(
        uri:     "user-groups/#{user_group_id}/user",
        method:  :post,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'manager'
        },
        payload: { user_id: user_id }
      )
    end

    # 사용자 그룹에서 사용자를 제거한다
    def delete_user_from_group(user_group_id:, user_id:, idempotency_key: nil)
      request(
        uri:     "user-groups/#{user_group_id}/user/#{user_id}",
        method:  :delete,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'manager'
        }
      )
    end
  end
end