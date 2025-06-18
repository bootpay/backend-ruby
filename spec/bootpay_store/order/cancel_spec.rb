# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "order cancel" do
    api      = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: 'vRle44QfyBj7nzJlBbeebqkbtlJVRTS2DQa9Adpz3d8=',
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.order_cancel(order_id: Time.current.to_i)
      puts response.data
    else
      puts token.data
    end
  end
end
