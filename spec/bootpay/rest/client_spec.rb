# frozen_string_literal: true

RSpec.describe Bootpay::Rest::Client do
  it "has a version number" do
    expect(Bootpay::Rest::Client::V2_VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
