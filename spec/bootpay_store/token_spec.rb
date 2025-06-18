# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "token" do
    # api      = BootpayStore::RestClient.new(
    #   server_key:  '67c92fb8d01640bb9859c612',
    #   private_key: 'ugaqkJ8/Yd2HHjM+W1TF6FZQPTmvx1rny5OIrMqcpTY=',
    #   mode:        'development'
    # )
    api      = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: 'vRle44QfyBj7nzJlBbeebqkbtlJVRTS2DQa9Adpz3d8=',
      mode:       'development'
    )
    response = api.request_access_token
    puts response.data

    "f32b56e3cba4de2c2a9819cf0bde00729e7772bae46e4d7c681e14f95cf5814a"
  end
end
