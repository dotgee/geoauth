module Filterable
  extend ActiveSupport::Concern

  class_methods do
    attr_accessor :searchable_attributes

    def searchable(*attrs)
      self.searchable_attributes = attrs
    end

    def filter(term)
      if term.blank?
        where(nil)
      else
        where(query, *search_terms(term))
      end
    end

    def query
      searchable_attributes.map { |attr| "lower(#{attr}) LIKE ?" }.join(' OR ')
    end

    def search_terms(term)
      ["%#{term.downcase}%"] * searchable_attributes.count
    end
  end
end
