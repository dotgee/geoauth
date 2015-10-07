module ApplicationHelper
  def avatar_url(user)
    if false && user.avatar_url.present?
      user.avatar_url
    else
      default_url = "#{root_url}images/guest.png"
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      "http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}"
    end
  end

  def btn_link_to(*args, &block)
    if block_given?
      options      = args.first || {}
      html_options = args.second
      btn_link_to(capture(&block), options, html_options)
    else
      name         = args[0]
      options      = args[1] || {}
      html_options = args[2] || {}
      html_options[:class] ? html_options[:class] += ' btn btn-primary' : html_options[:class] = 'btn btn-primary'
      link_to(name, options, html_options)
    end
  end


  #
  # for devise
  #
  def resource_name
    :user
  end
 
  def resource
    @resource ||= User.new
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
