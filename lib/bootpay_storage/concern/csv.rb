module BootpayStorage::Concern::Csv
  extend ActiveSupport::Concern

  included do


    # csv 파일 업로드 - 마이그레이션 할 때 사용
    # Comment by ehowlsla
    # Date: 2025-07-17
    def csv_file_upload(files:)
      csv_upload(
        uri:   'csvs',
        files: files
      )
    end

  end
end