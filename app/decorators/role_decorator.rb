class RoleDecorator < Draper::Decorator
  include Draper::LazyHelpers

  delegate_all

  def link_to_creator
    email = creator_email

    unless email.blank?
      return link_to admin_user_path(creator.id) do
        concat(fa_icon(:"envelope-o"))
        concat(' ')
        concat(email)
      end
    end
    ''
  end

  def creator_email
    return creator.email if creator && creator.email
    ''
  end

  def users_count
    user_roles.count
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
