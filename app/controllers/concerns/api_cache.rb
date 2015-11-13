module ApiCache
  extend ActiveSupport::Concern
  included do
    before_action :set_digests
    before_action :set_expire_time
  end
  def fetch_redis_cache(&block)
    if response = $redis.get("#{@digest}")
      response = JSON.load(response)
    else
      response = block.call
      $redis.set("#{@digest}", response)
      $redis.expire "#{@digest}", @expire_time
      response
    end
  end
  def set_digests
    begin
      timestamp = Project.order('projects.updated_at desc').first.updated_at.to_s
    rescue Exception => e
      timestamp = '0'
    end
    string = timestamp + permitted_params.inspect
    @digest = "#{controller_name}_#{action_name}_#{Digest::SHA1.hexdigest(string)}"
  end
  def set_expire_time
    @expire_time = ((Time.now + 1.day).beginning_of_day - Time.now).ceil
  end
end
