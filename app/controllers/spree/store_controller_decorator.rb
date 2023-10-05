module Spree
  class StoreControllerDecorator
    # Replace THEME_VIEW_LOAD_PATH with append_view_path
    def self.prepended(base)
      base.append_view_path -> { preview_mode? ? theme_preview_path : Spree::Theme::CURRENT_THEME_PATH }
      base.before_action :set_preview_theme, if: [:preview_mode?, :preview_theme] 

      base.helper_method :preview_mode? 
    end

    private

    def set_preview_theme
      params.merge!({ mode: 'preview', theme: preview_theme.id })
    end

    def preview_mode?
      cookies[:preview].present?
    end
    
    def theme_preview_path
      File.join(Spree::Theme::THEMES_PATH, cookies[:preview], 'views')
    end

    def preview_theme
      @preview_theme ||= Spree::Theme.find_by(name: cookies[:preview])
    end
  end

  ::Spree::StoreController.prepend self
end
