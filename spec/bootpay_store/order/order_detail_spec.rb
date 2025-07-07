# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "orders" do
    api = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: 'vRle44QfyBj7nzJlBbeebqkbtlJVRTS2DQa9Adpz3d8=',
      mode:       'development'
    )

    # api   = BootpayStore::RestClient.new(
    #   client_key: 'PFPsUXTj9A7ySxJSQ0w01g',
    #   secret_key: '4QoNzXcjT_H4brpq0AgM8ETtrBTFhabo3gmU_DJ148E=',
    #   mode:       'stage'
    # )
    token = api.request_access_token
    if token.success?
      response = api.order_detail(order_id: '685425f81c872444f161f00c')
      puts response.data.to_json
    else
      puts token.data
    end
  end
end
