require 'net/http'
class Purge < Net::HTTPRequest
  METHOD = "PURGE"
  REQUEST_HAS_BODY = false
  RESPONSE_HAS_BODY = false
end
