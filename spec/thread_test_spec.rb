# frozen_string_literal: true

RSpec.describe Bootpay::RestClient do
  it "thread test" do
    threads = []
    3000.times do |i|
      threads << Thread.new do
        puts "thread #{i} start"
        loop do
          response = HTTP.get('http://192.168.55.76:10000')
          puts "status: #{response.status.to_i}, headers: #{response.headers.map { |k, v| [k, v].join('=') }.join(', ')}"
          sleep(2)
        end
      end
    end
    threads.each { |thr| thr.join }
  end
end
