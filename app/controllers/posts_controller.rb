class PostsController < ApplicationController
  before_action :validate_post_params, only: [ :create ]

  TOPIC_NAME = "post_notifications"

  def create
    if @post = @user.posts.create(post_params)
      render json: { post: @post.as_json }
    else
      render json: { message: "Error: When trying to create record." }, status: 400
    end
  end

  def index
    MessagePublisher.call({ date: Time.now.strftime("%d/%m/%Y %H:%M") }, TOPIC_NAME)
    render json: { users: @user.posts.all.map(&:as_json) }
  end

  private

  def validate_post_params
    schema_path = Rails.root.join("app", "schemas", "post_schema.json")
    JsonSchemaValidator.validate!(params[:post].to_unsafe_h, schema_path)
  rescue JsonSchemaValidator::ValidationError => e
    render json: { error: e.message }, status: :bad_request
  end

  def post_params
    params.require(:post).permit(:caption, :image_url, :body)
  end
end
