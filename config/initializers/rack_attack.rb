# config/initializers/rack_attack.rb
class Rack::Attack
  # Basic IP Throttle
  throttle('req/ip', limit: 60, period: 1.minute) do |req|
    req.ip
  end

  # API Key Throttle
  throttle('req/api_key', limit: 20, period: 1.minute) do |req|
    req.env['HTTP_AUTHORIZATION']&.split(' ')&.last if req.path.start_with?('/api/endpoints')
  end

  self.throttled_responder = lambda do |_env|
    [429, { 'Content-Type' => 'application/json' }, [{ errors: [{ code: 'rate_limited', detail: 'Rate limit exceeded' }] }.to_json]]
  end
end
