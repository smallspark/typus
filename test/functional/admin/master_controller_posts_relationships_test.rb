require 'test/helper'

class Admin::PostsControllerTest < ActionController::TestCase

  ##
  # Post => has_many :comments
  ##

  def test_should_relate_comment_with_post_and_then_unrelate

    comment = comments(:without_post_id)
    post_ = posts(:published)
    @request.env['HTTP_REFERER'] = "/admin/posts/edit/#{post_.id}#comments"

    assert_difference('post_.comments.count') do
      post :relate, { :id => post_.id, 
                      :related => { :model => 'Comment', :field => 'comments', :id => comment.id } }
    end

    assert_response :redirect
    assert_redirected_to @request.env['HTTP_REFERER']
    assert_equal "Comment related to Post.", flash[:success]

    assert_difference('post_.comments.count', -1) do
      post :unrelate, { :id => post_.id, 
                        :resource => 'Comment', :field => 'comments', :resource_id => comment.id }
    end

    assert_response :redirect
    assert_redirected_to @request.env['HTTP_REFERER']
    assert_equal "Comment unrelated from Post.", flash[:success]

  end

  ##
  # Post => has_and_belongs_to_many :categories
  ##

  def test_should_relate_category_with_post_and_then_unrelate

    category = categories(:first)
    post_ = posts(:published)
    @request.env['HTTP_REFERER'] = "/admin/posts/edit/#{post_.id}#categories"

    assert_difference('category.posts.count') do
      post :relate, { :id => post_.id, 
                      :related => { :model => 'Category', :field => 'categories', :id => category.id } }
    end

    assert_response :redirect
    assert_redirected_to @request.env['HTTP_REFERER']
    assert_equal "Category related to Post.", flash[:success]

    assert_difference('category.posts.count', -1) do
      post :unrelate, { :id => post_.id, 
                        :resource => 'Category', :field => 'categories', :resource_id => category.id }
    end

    assert_response :redirect
    assert_redirected_to @request.env['HTTP_REFERER']
    assert_equal "Category unrelated from Post.", flash[:success]

  end

  ##
  # Post => has_many :photographs, :class_name => 'Picture'
  ##

  def test_should_relate_picture_with_post_and_then_unrelate

    picture = pictures(:first)
    post_ = posts(:published)
    @request.env['HTTP_REFERER'] = "/admin/posts/edit/#{post_.id}#categories"

    assert_difference('post_.photographs.count') do
      post :relate, { :id => post_.id, 
                      :related => { :model => 'Picture', :field => 'photographs', :id => picture.id } }
    end

    assert_response :redirect
    assert_redirected_to @request.env['HTTP_REFERER']
    assert_equal "Picture related to Post.", flash[:success]

    assert_difference('post_.photographs.count', -1) do
      post :unrelate, { :id => post_.id, 
                        :resource => 'Picture', :field => 'photographs', :resource_id => picture.id }
    end

    assert_response :redirect
    assert_redirected_to @request.env['HTTP_REFERER']
    assert_equal "Picture unrelated from Post.", flash[:success]

  end

  ##
  # Post => has_many :assets, :as => resource (Polimorphic)
  ##

  def test_should_relate_asset_with_post_and_then_unrelate

    post_ = posts(:published)

    @request.env['HTTP_REFERER'] = "/admin/posts/edit/#{post_.id}#assets"

    assert_difference('post_.assets.count', -1) do
      get :unrelate, { :id => post_.id,  
                       :resource => 'Asset', :field => 'assets', :resource_id => post_.assets.first.id }
    end

    assert_response :redirect
    assert_redirected_to @request.env['HTTP_REFERER']
    assert_equal "Asset unrelated from Post.", flash[:success]

  end

end
