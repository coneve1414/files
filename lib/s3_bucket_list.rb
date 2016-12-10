require 'aws-sdk'
require 'uri'

class S3BucketList < Nanoc::DataSource
  identifier :s3_bucket_list

  def items
    s3 = ::Aws::S3::Client.new({
                                   region: @config[:region] || 'us-east-1',
                                   access_key_id: @config[:access_key_id] || ENV['S3_ACCESS_KEY_ID'],
                                   secret_access_key: @config[:secret_access_key] || ENV['S3_SECRET_ACCESS_KEY']
                               })

    bucket_list = s3.list_objects_v2({
                                         bucket: @config[:bucket],
                                         prefix: @config[:list_prefix]
                                     })

    bucket_list.contents.map do |object|
      new_item(File.basename(object.key), {
          basename: File.basename(object.key),
          s3_key: object.key,
          s3_uri: "https://s3.amazonaws.com/#{@config[:bucket]}/#{URI.escape(object.key)}"
      }, '/' + object.key)
    end
  end
end
