module Spree
  class ThemesTemplate < Spree::Base
    DEFAULT_LOCALE = 'en'
    DEFAULT_PATH = Rails.root.join('public', 'vinsol_spree_themes')
    ASSETS_FILE_EXTENSIONS = ['.js', '.css']

    # This attr attribute is used when templates are created from the admin end.
    attr_accessor :created_by_admin

    ## VALIDATIONS ##
    validates :path, presence: true
    validates :format, inclusion: Mime::SET.symbols.map(&:to_s),
                       allow_nil: true
    validates :locale, inclusion: I18n.available_locales.map(&:to_s)
    validates :handler, inclusion: ActionView::Template::Handlers.extensions.map(&:to_s),
                        allow_nil: true

    ## ASSOCIATIONS ##
    belongs_to :theme

    ## CALLBACKS ##
    before_validation :set_default_locale, unless: :locale?
    before_create :set_public_path, if: :created_by_admin
    after_save :update_cache_timestamp
    after_save :update_public_file
    after_save :precompile_assets, if: [:theme_published?, :assets_file?]

    ## DELEGATES ##
    delegate :name, to: :theme, prefix: true

    self.whitelisted_ransackable_attributes = %w( name path format handler )

    private

    def update_cache_timestamp
      Rails.cache.write(Spree::ThemesTemplate::CacheResolver.cache_key, Time.current)
    end

    def set_default_locale
      self.locale = DEFAULT_LOCALE
    end

    def set_public_path
      self.path = File.join(DEFAULT_PATH, theme_name, path)
    end

    def update_public_file
      FileGeneratorService.create(self)
    end

    def precompile_assets
      assets_compiler = AssetsPrecompilerService.new(theme)
      assets_compiler.minify
      assets_compiler.copy_assets
    end

    def theme_published?
      theme.published?
    end

    def assets_file?
      ASSETS_FILE_EXTENSIONS.include? File.extname(name)
    end
  end
end
