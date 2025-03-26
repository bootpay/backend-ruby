module BootpayStorage::Concern::Image
  extend ActiveSupport::Concern

  included do


    # REST API로 본인인증 요청하기
    # Comment by Gosomi
    # Date: 2022-11-02
    def image_upload(image_data:, image_name:)
      upload(
        uri:     'images',
        image_data: image_data,
        image_name: image_name
      )
    end

  end
end