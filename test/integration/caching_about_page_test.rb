require 'test_helper'

class CachingAboutPageTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test "it works!" do
    visit varnish_uri(about_path)
    assert_not_nil page.response_headers['X-Varnish']
  end

  test "caches about page for a long time" do
    visit varnish_uri(about_path)
    assert_match "max-age=#{1.hour}", page.response_headers['Cache-Control']
  end

  test "forces public cache to be private" do
    visit varnish_uri(about_path)
    assert_match "private", page.response_headers['Cache-Control']
  end

  test "removes set-cookie header if cache-control is public" do
    visit varnish_uri(about_path)
    assert_nil page.response_headers["Set-Cookie"]
  end
end
