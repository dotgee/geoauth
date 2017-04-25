module Admin
  class GroupsController < BaseController
    # GET /groups
    # GET /groups.json
    def index
      @groups = Group.list.all.decorate

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @groups }
      end
    end

    # GET /groups/1
    # GET /groups/1.json
    def show
      @group = Group.find(params[:id])
      # @members = @group.members.order(:email).page(params[:page]).per(params[:per])
      @q = @group.members.ransack(params[:q])
      @members = PaginatingDecorator.decorate(@q.result.order(:email).page(params[:page]).per(20))

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @group }
      end
    end

    # GET /groups/new
    # GET /groups/new.json
    def new
      @group = Group.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @group }
      end
    end

    # GET /groups/1/edit
    def edit
      @group = Group.find(params[:id])
      @users = PaginatingDecorator.decorate(@group.members.page(params[:page]).per(50))
    end

    # POST /groups
    # POST /groups.json
    def create
      @group = Group.new(create_group_params)

      respond_to do |format|
        if @group.save
          format.html { redirect_to admin_groups_url, notice: "Group #{@group.name} was successfully created." }
          format.json { render json: @group, status: :created, location: @group }
        else
          format.html { render action: "new" }
          format.json { render json: @group.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /groups/1
    # PUT /groups/1.json
    def update
      @group = Group.find(params[:id])

      respond_to do |format|
        if @group.update_attributes(update_group_params)
          format.html { redirect_to admin_groups_url, notice: "Group #{@group.name} was successfully updateed." }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @group.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /groups/1
    # DELETE /groups/1.json
    def destroy
      @group = Group.find(params[:id])
      @group.destroy

      respond_to do |format|
        format.html { redirect_to groups_url }
        format.json { head :no_content }
      end
    end

    private

    def create_group_params
      params.require(:group).permit([:name, :description])
    end

    def update_group_params
      params.require(:group).permit([:description, { role_ids: [] }])
    end
  end
end
