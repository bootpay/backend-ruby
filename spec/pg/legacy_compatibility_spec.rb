# frozen_string_literal: true

RSpec.describe 'Bootpay legacy compatibility' do
  it 'keeps application_id/private_key initialization working' do
    api = Bootpay::Api.new(
      application_id: 'legacy_application_id',
      private_key: 'legacy_private_key',
      mode: 'development'
    )

    expect(api.instance_variable_get(:@application_id)).to eq('legacy_application_id')
    expect(api.instance_variable_get(:@private_key)).to eq('legacy_private_key')
    expect(api.instance_variable_get(:@client_key)).to be_nil
    expect(api.instance_variable_get(:@secret_key)).to be_nil
    expect(api.instance_variable_get(:@mode)).to eq('development')
  end

  it 'keeps legacy data.token extraction working' do
    api = Bootpay::Api.new(
      application_id: 'legacy_application_id',
      private_key: 'legacy_private_key',
      mode: 'development'
    )
    allow(api).to receive(:request).and_return(
      Bootpay::Response.new(true, { data: { token: 'legacy_access_token' } })
    )

    api.request_access_token

    expect(api.instance_variable_get(:@token)).to eq('legacy_access_token')
  end

  it 'returns synthetic empty token response without HTTP call for client_key/secret_key' do
    api = Bootpay::Api.new(
      client_key: 'ck',
      secret_key: 'sk',
      mode: 'development'
    )
    expect(api).not_to receive(:request)

    response = api.request_access_token

    expect(response.success?).to eq(true)
    expect(response.data[:access_token]).to eq('')
    expect(response.data[:expire_in]).to eq(0)
    expect(api.instance_variable_get(:@token)).to be_nil
  end

  it 'uses Basic authorization for client_key/secret_key mode' do
    api = Bootpay::Api.new(
      client_key: 'ck',
      secret_key: 'sk',
      mode: 'development'
    )

    expect(api.send(:authorization_header)).to eq(
      "Basic #{Base64.strict_encode64('ck:sk')}"
    )
  end

  it 'uses Bearer authorization for legacy application_id/private_key mode' do
    api = Bootpay::Api.new(
      application_id: 'legacy_application_id',
      private_key: 'legacy_private_key',
      mode: 'development'
    )
    api.instance_variable_set(:@token, 'legacy_access_token')

    expect(api.send(:authorization_header)).to eq('Bearer legacy_access_token')
  end

  it 'returns nil authorization when token has not been issued yet for legacy mode' do
    api = Bootpay::Api.new(
      application_id: 'legacy_application_id',
      private_key: 'legacy_private_key',
      mode: 'development'
    )

    expect(api.send(:authorization_header)).to be_nil
  end
end
