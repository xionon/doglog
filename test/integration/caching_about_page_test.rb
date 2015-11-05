require 'test_helper'

class CachingAboutPageTest < ActionDispatch::IntegrationTest
  setup do
    @anonymous = new_session
  end

  test "it works!" do
    @anonymous.visit varnish_uri(about_path)
    assert_not_nil @anonymous.response_headers['X-Varnish']
  end

  test "caches about page for a long time" do
    @anonymous.visit varnish_uri(about_path)
    assert_match "max-age=#{1.hour}", @anonymous.response_headers['Cache-Control']
  end

  test "forces public cache to be private" do
    @anonymous.visit varnish_uri(about_path)
    assert_match "private", @anonymous.response_headers['Cache-Control']
  end

  test "removes set-cookie header if cache-control is public" do
    @anonymous.visit varnish_uri(about_path)
    assert_nil @anonymous.response_headers["Set-Cookie"]
  end
end
