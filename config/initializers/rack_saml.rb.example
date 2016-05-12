Rails.application.config.middleware.insert_after Rack::ETag, Rack::Saml, {
  config:         "#{Rails.root}/config/shib/rack-saml.yml",
  metadata:       "#{Rails.root}/config/shib/metadata.yml",
  attribute_map:  "#{Rails.root}/config/shib/attribute-map.yml"
}
