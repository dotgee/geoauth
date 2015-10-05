class UserDecorator < Draper::Decorator
  include Draper::LazyHelpers

  delegate_all

  #def name
  #  [ first_name, last_name ].compact.join(' ')
  #end

  def created_date
    created_at.strftime('%d/%m/%Y')
  end

  def roles_count
    roles.count
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
