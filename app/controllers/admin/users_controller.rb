module Admin
  class UsersController < BaseController
    # GET /admin/users
    # GET /admin/users.json
    def index
      # @users = User.all
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: UsersDatatable.new(view_context) }
      end
      #raise request.inspect
    end
  
    # GET /admin/users/1
    # GET /admin/users/1.json
    def show
      @user = User.find(params[:id])
  
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @user }
      end
    end
  
    # GET /admin/users/new
    # GET /admin/users/new.json
    def new
      @user = User.new
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @user }
      end
    end
  
    # GET /admin/users/1/edit
    def edit
      @user = User.find(params[:id])
    end
  
    # POST /admin/users
    # POST /admin/users.json
    def create
      @user = User.new(params[:user])
  
      respond_to do |format|
        if @user.save
          format.html { redirect_to admin_users_path, notice: 'User was successfully created.' }
          format.json { render json: @user, status: :created, location: @user }
        else
          format.html { render action: "new" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PUT /admin/users/1
    # PUT /admin/users/1.json
    def update
      @user = User.find(params[:id])
  
      if params[:user] && !params[:user][:password].blank?
        result = @user.update_attributes(params[:user])
      else
        result = @user.update_without_password(params[:user])
      end

      respond_to do |format|
        if result
          format.html { redirect_to admin_users_path, notice: "User #{@user.full_name} was successfully updated." }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /admin/users/1
    # DELETE /admin/users/1.json
    def destroy
      @user = User.find(params[:id])
      @user.destroy
      respond_to do |format|
        format.html { redirect_to admin_users_url }
        format.json { head :no_content }
      end
    end
  end
end
