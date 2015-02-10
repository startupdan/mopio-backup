require "dotenv"

Dotenv.load

Model.new(:mopio, "Database backup") do

  database PostgreSQL do |db|
    db.name               = ENV["DB_NAME"]
    db.additional_options = ["-xc", "-E=utf8"]
  end

  time = Time.now
  if time.day == 1 # first day of the month
    storage_id = :monthly
    keep = 6
  elsif time.sunday?
    storage_id = :weekly
    keep = 3
  else
    storage_id = :daily
    keep = 12
  end

  store_with S3 do |s3|
    s3.access_key_id     = ENV['AWS_ACCESS_KEY_ID']
    s3.secret_access_key = ENV["AWS_SECRET_ACCESS_KEY"]
    s3.region            = ENV["AWS_REGION"]
    s3.bucket            = ENV["S3_BUCKET_NAME"]
    s3.chunk_size        = 10 # MiB
    s3.encryption        = :aes256
  end

  compress_with Bzip2

end
