module Spree
  class FragmentCacheController < ActionController::Base
    CACHE_PATH_REGEX = /\A(views\/spree_cache)/
    CACHE_KEY = 'spree_cache'

    def clear_cache
      Rails.logger.info 'Expiring fragment caching for template...'
      expire_fragment(CACHE_PATH_REGEX)
    end
  end
end
