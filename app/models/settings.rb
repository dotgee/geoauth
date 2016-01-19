class Settings < Settingslogic
  # used in conjonction with figaro
  source "#{Rails.root}/config/settings.yml"
  namespace Rails.env
end
