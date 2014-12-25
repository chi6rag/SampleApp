require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  test "layout links" do

    # Get the root path (Home page)
    # Verify that the right page template is rendered
    # Check for the correct links to the Home, Help, About, and Contact pages

    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", home_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", help_path

  end

end
