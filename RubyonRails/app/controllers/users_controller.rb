class UsersController < ApplicationController
  before_action :check_permission, only: [:new, :create]
  
  def index
    if params[:query]
      split_query = params[:query].split(' ')
      if split_query.length > 1
        # Case when both first name and last name are typed
        @users = User.where('lower(fname) LIKE :first AND lower(lname) LIKE :last', 
                            first: "#{split_query.first.downcase}%", 
                            last: "#{split_query.last.downcase}%")
      else
        # Case when either first name, last name, or email is typed
        @users = User.where('lower(fname) LIKE :query OR lower(lname) LIKE :query OR lower(email) LIKE :query', 
                            query: "%#{params[:query].downcase}%")
      end
    else
      @users = User.all
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    # @user.role = current_user.local_moderator? ? "regular_user" : @user.role
    puts "Current user #{@user.inspect}"

    key = Key.find_by(activation_code: params[:registration_key])
    if valid_registration_key?(key)
      tenant = Tenant.create!
      @user.tenant_id = tenant.id
      @user.role = 'local_moderator'

      if @user.save
        key.update(used: true)
        # User, tenant, and key update successful
        puts "New user (local moderator) was saved with Tenant ID: #{tenant.id}"
        # redirect_to users_path, notice: 'User was successfully created.'
      else
        # Handle user creation failure
        puts "Failed to create user"
        render :new
      end
    else
      # Handle invalid key
      flash[:alert] = 'Invalid registration key.'
      render :new
    end
  end

  private
  def valid_registration_key?(key)
    key.present? && !key.used && (key.expiration.nil? || key.expiration > Time.current)
  end

  private
  def check_permission
    unless current_user.local_moderator? || current_user.global_moderator?
      redirect_to users_path, alert: "You don't have permission to perform this action."
    end
  end

  def user_params
    params.require(:user).permit(:fname, :lname, :email, :password, :password_confirmation)
    Rails.logger("DEBUG: #{@user.email.inspect}")
  end
end