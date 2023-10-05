module Spree
  class ThemesTemplate::CacheResolver < ActionView::Resolver
    FRAGMENT_CACHE_PATH_REGEX = /\A(views\/spree_cache)/
    FRAGMENT_CACHE_KEY = 'spree_cache'

    def clear_cache_if_necessary
      last_updated = Rails.cache.fetch(self.class.cache_key) { Time.current }

      if @cache_last_updated.nil? || @cache_last_updated < last_updated
        Rails.logger.info 'Expiring cache and reloading new template content....'
        # Expiring fragment caching used in Spree views 
        ActionController::Base.new.expire_fragment(FRAGMENT_CACHE_PATH_REGEX)
        # Clearing template caching.
        clear_cache

        @cache_last_updated = last_updated
      end
    end

    private

    def clear_cache
      # Implement your cache clearing logic here if necessary.
      # For example, if you are caching templates, you might need to clear those caches.
      # This depends on your specific caching implementation.
    end

    def find_templates(name, prefix, partial, details)
      # This method should return an array of template objects.
      # Implement the logic to find templates here.
      # For example, you might want to find templates from a database or a custom source.
      # Return an array of ActionView::Template objects with the found templates.
      []
    end

    def self.cache_key
      ActiveSupport::Cache.expand_cache_key('updated_at', 'loaded_templates')
    end
  end
end
