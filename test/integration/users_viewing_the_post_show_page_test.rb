require 'test_helper'

class UsersViewingThePostShowPageTest < ActionDispatch::IntegrationTest
  setup do
    @dog = Dog.create!(name: "Dog")
    @bark = @dog.posts.create(body: "Old body")
  end

  test "cached results are returned for non-authenticated users" do
    anonymous = new_session
    anonymous.visit varnish_uri(dog_post_path(@dog, @bark))

    @bark.update_attributes(:body => "New body")

    anonymous.visit varnish_uri(dog_post_path(@dog, @bark))

    assert anonymous.has_content?("Old body"),
           "Expected content to still include Old body for anonymous"
    refute anonymous.has_content?("New body"),
           "Expected content to not include New body for anonymous"
  end

  test "non-cached results are returned for authenticated users" do
    authenticated = new_session("alec.hipshear@gmail.com")
    authenticated.visit varnish_uri(new_user_session_path)

    @bark.update_attributes(:body => "New body")

    authenticated.visit varnish_uri(dog_post_path(@dog, @bark))

    refute authenticated.has_content?("Old body"),
           "Expected page to not include Old body for logged-in user"
    assert authenticated.has_content?("New body"),
           "Expected page to include New body for logged-in user"
  end

  test "visiting a page after a logged-in user sees it first doesn't mean the page is un-cached" do
    anonymous = new_session
    alec = new_session('alec.hipshear@gmail.com')

    alec.visit varnish_uri(dog_post_path(@dog, @bark))
    anonymous.visit varnish_uri(dog_post_path(@dog, @bark))

    @bark.update_attributes(:body => "New body")

    alec.visit varnish_uri(dog_post_path(@dog, @bark))
    assert alec.has_content?("New body")

    anonymous.visit varnish_uri(dog_post_path(@dog, @bark))
    assert anonymous.has_content?("Old body")
  end
end
