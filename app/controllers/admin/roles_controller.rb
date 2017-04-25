module Admin
  class RolesController < BaseController
    # GET /roles
    # GET /roles.json
    def index
      @roles = Role.list.all.decorate

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @roles }
      end
    end

    # GET /roles/1
    # GET /roles/1.json
    def show
      @role = Role.find(params[:id])
      # @members = @role.users.order(:email).page(params[:page]).per(params[:per])
      @q = @role.users.ransack(params[:q])
      @members = PaginatingDecorator.decorate(@q.result.order(:email).page(params[:page]).per(20))

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @role }
      end
    end

    # GET /roles/new
    # GET /roles/new.json
    def new
      @role = Role.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @role }
      end
    end

    # GET /roles/1/edit
    def edit
      @role = Role.find(params[:id])
      @users = PaginatingDecorator.decorate(@role.users.page(params[:page]).per(50))
    end

    # POST /roles
    # POST /roles.json
    def create
      @role = Role.new(create_role_params)

      respond_to do |format|
        if @role.save
          format.html { redirect_to admin_roles_url, notice: "Role #{@role.name} was successfully created." }
          format.json { render json: @role, status: :created, location: @role }
        else
          format.html { render action: "new" }
          format.json { render json: @role.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /roles/1
    # PUT /roles/1.json
    def update
      @role = Role.find(params[:id])

      respond_to do |format|
        if @role.update_attributes(update_role_params)
          format.html { redirect_to admin_roles_url, notice: "Role #{@role.name} was successfully updated." }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @role.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /roles/1
    # DELETE /roles/1.json
    def destroy
      @role = Role.find(params[:id])
      @role.destroy

      respond_to do |format|
        format.html { redirect_to admin_roles_url }
        format.json { head :no_content }
      end
    end

    private

    def create_role_params
      params.require(:role).permit(:name, :description)
    end

    def update_role_params
      params.require(:role).permit(:description)
    end
  end
end
