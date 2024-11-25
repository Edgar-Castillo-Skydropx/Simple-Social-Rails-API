class UserController < ApplicationController
  before_action :validate_user_params, only: [ :create ]

  def create
    @found = User.find_by(email: params[:user][:email])

    if @found&.update(user_params([ :email ]))
      return render json: {
        message: "User updated successfully",
        user: user_map(@found),
        as_json: @found.as_json(only: [ :id, :email ])
      }, status: :ok
    end

    @user = User.new(user_params)

    if @user.save
      render json: {
        message: "User created successfully",
        user: user_map(@user),
        as_json: @user.as_json(only: [ :id, :email ])
      }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    render json: { users: User.all.map(&:as_json) }
  end

  private

  def validate_user_params
    schema_path = Rails.root.join("app", "schemas", "user_schema.json")
    JsonSchemaValidator.validate!(params[:user].to_unsafe_h, schema_path)
  rescue JsonSchemaValidator::ValidationError => e
    render json: { error: e.message }, status: :bad_request
  end

  def user_params(excluded_keys = [])
    permitted_keys = [ :name, :email, :age, :last_name, :first_name, :password ]
    params.require(:user).permit(permitted_keys - excluded_keys.map(&:to_sym))
  end

  def user_map(user)
    { id: user[:id], email: user[:email], first_name: user[:first_name], last_name: user[:last_name] }
  end
end
