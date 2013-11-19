class UsersDatatable
  delegate :params, :h, :link_to, :edit_admin_user_path, :admin_user_path, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: User.count,
      iTotalDisplayRecords: User.count,
      aaData: data
    }
  end

  private

  def data
    resources.map do |resource|
      [
        "##{resource.id}",
        link_to(resource.email, edit_admin_user_path(resource)),
        h(resource.full_name),
        [ link_to('Edit', edit_admin_user_path(resource), class: 'm-btn mini blue-stripe'), link_to('Destroy', admin_user_path(resource), method: :delete, data: { confirm: 'Are you sure?' }, class: 'm-btn mini red-stripe') ].join(' ')
      ]
    end
  end

  def resources
    @resources ||= fetch_resources
  end

  def fetch_resources
    resources = User.order("#{sort_column} #{sort_direction}")
    resources = resources.page(page).per(per_page)
    if params[:sSearch].present?
      resources = resources.where("username like :search or email like :search or first_name like :search or last_name like :search", search: "%#{params[:sSearch]}%")
    end
    resources
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[id email username first_name, last_name]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
