class AuthenticationController < ApplicationController
  skip_before_action :authenticate
  before_action :validate_params

  def login
    user = User.find_by(username: params[:username])
    authenticated_user = user&.authenticate(params[:password])

    if authenticated_user
      token = JsonWebToken.encode(user_id: user.id)
      expires_at = JsonWebToken.decode(token)[:exp]

      render json: { token:, expires_at: }, status: :ok
    else
      render json: { error: "unauthorized" }, status: :unauthorized
    end
  end

  def validate_params
    schema_path = Rails.root.join("app", "schemas", "login_schema.json")
    JsonSchemaValidator.validate!(params.except(:controller, :action, :authentication).to_unsafe_h, schema_path)
  rescue JsonSchemaValidator::ValidationError => e
    render json: { error: e.message }, status: :bad_request
  end
end
