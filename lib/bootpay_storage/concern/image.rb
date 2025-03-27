module BootpayStorage::Concern::Image
  extend ActiveSupport::Concern

  included do


    # REST API로 본인인증 요청하기
    # Comment by Gosomi
    # Date: 2022-11-02
    def image_upload(images:)
      upload(
        uri:     'images',
        images: images
      )
    end

  end
end