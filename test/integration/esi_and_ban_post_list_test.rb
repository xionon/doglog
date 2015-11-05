require 'test_helper'

class EsiAndBanPostListTest < ActionDispatch::IntegrationTest
  setup do
    @dog = Dog.create(name: "Duffer")
    3.times{ @dog.posts.create(body: "Woof.") }
    @alec = new_session("alec.hipshear@gmail.com")
    @user = User.last
    @dog.user = @user
    @dog.save!
  end

  test "loads a cached copy of the posts using ESI" do
    @alec.visit varnish_uri(dog_path(@dog))
    assert @alec.has_css? "form.new_post"
    refute @alec.has_content? "New Body"

    @dog.posts.last.update_attribute(:body, "New Body")
    @alec.visit varnish_uri(dog_path(@dog))

    refute @alec.has_content?("New Body"),
      "Page should not be updated when content is side-loaded"
  end

  test "refreshes the list of posts when posted using the form" do
    @alec.visit varnish_uri(dog_path(@dog))
    assert @alec.has_css? "form.new_post"
    refute @alec.has_content? "New Body"

    @alec.within 'form.new_post' do
      @alec.fill_in 'post_body', with: "New Body"
      @alec.click_button 'Save'
    end

    assert @alec.has_content?('New Body'),
      "Page should have been refreshed after create action"
  end
end
