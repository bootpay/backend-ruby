# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "update mall setting" do
    api      = BootpayStore::RestClient.new(
      client_key: ENV['BP_CLIENT_KEY'],
      secret_key: ENV['BP_SECRET_KEY'],
      mode:       'development'
    )
    response = api.update_mall_setting(
      name:                                   '부트페이 테스트 몰',
      description:                            '부트페이 SDK 테스트로 갱신된 몰 설명',
      use_notice:                             true,
      use_qna:                                true,
      use_faq:                                true,
      customer_service_center_operation_time: {
        mon: { use: true, start_hour: 9, start_minute: 0, end_hour: 18, end_minute: 0 },
        tue: { use: true, start_hour: 9, start_minute: 0, end_hour: 18, end_minute: 0 },
        wed: { use: true, start_hour: 9, start_minute: 0, end_hour: 18, end_minute: 0 },
        thu: { use: true, start_hour: 9, start_minute: 0, end_hour: 18, end_minute: 0 },
        fri: { use: true, start_hour: 9, start_minute: 0, end_hour: 18, end_minute: 0 },
        sat: { use: false, start_hour: 0, start_minute: 0, end_hour: 0, end_minute: 0 },
        sun: { use: false, start_hour: 0, start_minute: 0, end_hour: 0, end_minute: 0 }
      }
    )
    puts response.data.to_json
  end
end
