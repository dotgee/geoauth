module Admin
  class UsersController < BaseController
    # GET /admin/users
    # GET /admin/users.json
    def index
      #
      # sanitize ransack parameter
      #
      params.delete(:q) if params[:q] && params[:q][User.search_query].blank?

      @q = User.filter(params[:q])

      #
      # TODO: refactor this
      # could test if query or not to avoid to_a and pagination on array
      # could avoid distinct: true because where using to_a.uniq
      # SEE: http://stackoverflow.com/questions/6545990/rails-3-kaminari-pagination-for-an-simple-array
      # to optimize pagination.
      #
      @users = @q.result(distinct: true)
                 .includes(:roles, :groups)
                 .select(params[:q].nil? ? 'users.*' : 'users.*, groups.name, roles.name')
                 .order(:email)
                 .to_a.uniq
      # @users = PaginatingDecorator.decorate(Kaminari.paginate_array(@users).page(params[:page]).per(20))
      # @users = PaginatingDecorator.decorate(@q.result.includes(:roles, :groups).order(:email).page(params[:page]).per(20))

      respond_to do |format|
        format.html {
          @users = PaginatingDecorator.decorate(Kaminari.paginate_array(@users).page(params[:page]).per(20))
        } # index.html.erb
        format.json { render json: UsersDatatable.new(view_context) }
        format.csv { send_data UsersCsvGenerator.new(@users).run, filename: "users-#{Date.today}.csv" }
      end
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
      @user = User.new(user_params)

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
        result = @user.update_attributes(user_params)
      else
        result = @user.update_without_password(user_params)
      end

      respond_to do |format|
        if result
          format.html { redirect_to admin_users_path, notice: "User #{@user.name} was successfully updated." }
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

    private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :remember_me, :username, :enabled, :first_name, :last_name, { role_ids: [] },  { group_ids: [] } )
    end
  end
end
