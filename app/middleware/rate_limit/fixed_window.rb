class FixedWindow
  TIME_WINDOW  = 3600
  MAX_REQUESTS = 100

  private_constant :TIME_WINDOW, :MAX_REQUESTS

  def initialize(app)
    @app = app
  end

  def call(env)
    user = env['REMOTE_ADDR']
    key  = "ip:#{user}"

    count = $redis.get(key)
    if count.nil?
      $redis.set(key, 0)
      $redis.expire(key, TIME_WINDOW)
    end

    if count.to_i < MAX_REQUESTS
      $redis.incr(key)
      status, headers, body = @app.call(env)
      [
        status,
        headers,
        body
      ]
    else
      [
        429,
        {},
        [message(key)]
      ]
    end
  end

  private
    def message(key)
      seconds_left = $redis.ttl(key)

      "Rate limit exceeded. Try again in #{seconds_left} seconds."
    end
end
