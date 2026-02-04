---
name: rails-controller
description: Create Rails controllers with RESTful actions, tests, and proper patterns
disable-model-invocation: true
---

# Create Rails Controller: $ARGUMENTS

## Step 1: Generate Controller

```bash
# For a resource controller
bin/rails generate controller <Plural> index show new create edit update destroy

# For API controller
bin/rails generate controller Api::V1::<Plural> index show create update destroy
```

## Step 2: Define Routes

Edit `config/routes.rb`:

```ruby
Rails.application.routes.draw do
  # Standard RESTful resource
  resources :articles

  # Nested resource
  resources :articles do
    resources :comments, only: [:create, :destroy]
  end

  # API namespace
  namespace :api do
    namespace :v1 do
      resources :articles, only: [:index, :show, :create, :update, :destroy]
    end
  end

  # Custom actions
  resources :articles do
    member do
      post :publish
    end
    collection do
      get :search
    end
  end
end
```

## Step 3: Implement Controller

`app/controllers/articles_controller.rb`:

```ruby
class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :authorize_article, only: [:edit, :update, :destroy]

  def index
    @articles = Article.published.recent.page(params[:page])
  end

  def show
  end

  def new
    @article = current_user.articles.build
  end

  def create
    @article = current_user.articles.build(article_params)

    if @article.save
      redirect_to @article, notice: 'Article was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: 'Article was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_url, notice: 'Article was successfully deleted.'
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def authorize_article
    redirect_to articles_url, alert: 'Not authorized' unless @article.user == current_user
  end

  def article_params
    params.require(:article).permit(:title, :body, :published, tag_ids: [])
  end
end
```

## API Controller Pattern

`app/controllers/api/v1/articles_controller.rb`:

```ruby
module Api
  module V1
    class ArticlesController < ApplicationController
      before_action :authenticate_api_user!
      before_action :set_article, only: [:show, :update, :destroy]

      def index
        @articles = Article.published.recent
        render json: @articles
      end

      def show
        render json: @article
      end

      def create
        @article = current_user.articles.build(article_params)

        if @article.save
          render json: @article, status: :created
        else
          render json: { errors: @article.errors }, status: :unprocessable_entity
        end
      end

      def update
        if @article.update(article_params)
          render json: @article
        else
          render json: { errors: @article.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @article.destroy
        head :no_content
      end

      private

      def set_article
        @article = Article.find(params[:id])
      end

      def article_params
        params.require(:article).permit(:title, :body, :published)
      end
    end
  end
end
```

## Step 4: Write Controller Tests

`test/controllers/articles_controller_test.rb`:

```ruby
require 'test_helper'

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @article = articles(:one)
  end

  test "should get index" do
    get articles_url
    assert_response :success
  end

  test "should get show" do
    get article_url(@article)
    assert_response :success
  end

  test "should redirect new when not logged in" do
    get new_article_url
    assert_redirected_to login_url
  end

  test "should get new when logged in" do
    sign_in @user
    get new_article_url
    assert_response :success
  end

  test "should create article" do
    sign_in @user
    assert_difference('Article.count') do
      post articles_url, params: {
        article: { title: 'New Title', body: 'Content' }
      }
    end
    assert_redirected_to article_url(Article.last)
  end

  test "should not create invalid article" do
    sign_in @user
    assert_no_difference('Article.count') do
      post articles_url, params: { article: { title: '' } }
    end
    assert_response :unprocessable_entity
  end

  test "should update article" do
    sign_in @user
    patch article_url(@article), params: {
      article: { title: 'Updated' }
    }
    assert_redirected_to article_url(@article)
    @article.reload
    assert_equal 'Updated', @article.title
  end

  test "should destroy article" do
    sign_in @user
    assert_difference('Article.count', -1) do
      delete article_url(@article)
    end
    assert_redirected_to articles_url
  end
end
```

## Step 5: Run Tests

```bash
bin/rails test test/controllers/articles_controller_test.rb
```

## Controller Best Practices

1. **Keep controllers thin** - Business logic goes in models/services
2. **Use before_action** - DRY up finding records and auth
3. **Strong parameters** - Always whitelist permitted params
4. **Respond appropriately** - Correct status codes and formats
5. **Handle errors gracefully** - Rescue common exceptions
6. **Authorize actions** - Check user permissions

## Checklist

- [ ] Routes defined in routes.rb
- [ ] before_actions for common operations
- [ ] Strong parameters implemented
- [ ] Proper HTTP status codes
- [ ] Authorization checks in place
- [ ] Controller tests written
- [ ] Views created (if not API)
