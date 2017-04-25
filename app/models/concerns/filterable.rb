module Filterable
  extend ActiveSupport::Concern

  class_methods do
    attr_accessor :searchable_attributes

    def searchable(*attrs)
      self.searchable_attributes = attrs
    end

    def filter(query)
      if query.blank?
        ransack(nil)
      else
        q =
          if query.is_a? Hash
            query
          else
            tq = {}
            tq[search_query.to_sym] = query # *search_terms(term)
          end
        ransack(q)
      end
    end

    def search_query
      # searchable_attributes.map { |attr| "lower(#{attr}) LIKE ?" }.join(' OR ')
      "#{searchable_attributes.join('_or_')}_cont"
    end

    def search_terms(term)
      # ["%#{term.downcase}%"] * searchable_attributes.count
      term
    end
  end
end
