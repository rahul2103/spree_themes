module Spree
  module Admin
    class ThemesController < Spree::Admin::BaseController
      before_action :load_theme, only: [:state_change, :destroy, :download]
      before_action :load_themes

      def index
        @theme = Spree::Theme.new
      end

      def upload
        @theme = Spree::Theme.new(theme_params)
        if @theme.save
          flash[:notice] = I18n.t('spree.admin.themes.upload.success', name: @theme.name)
          redirect_to admin_themes_path
        else
          flash[:error] = I18n.t('spree.admin.themes.upload.failure', name: @theme.name)
          render :index
        end
      end

      def state_change
        state = case params[:state]
                when 'compiled' then @theme.compile
                when 'published' then @theme.publish
                else false
                end
        if state
          flash[:notice] = I18n.t('spree.admin.themes.state_change.success', state: params[:state], name: @theme.name)
          redirect_to admin_themes_path
        else
          flash[:error] = I18n.t('spree.admin.themes.state_change.failure', state: params[:state], name: @theme.name, errors: @theme.errors.full_messages.join(', '))
          render :index
        end
      end

      def download
        begin
          zipfile = ZipFileBuilder.new(@theme)
          zipfile.archive
          send_file(zipfile.output_path, disposition: 'attachment', filename: zipfile.name)
        rescue Exception => e
          flash[:error] = I18n.t('spree.admin.themes.download.failure', name: @theme.name, errors: e.message)
          render :index
        end
      end

      def destroy
        if @theme.destroy
          flash[:notice] = I18n.t('spree.admin.themes.destroy.success', name: @theme.name)
          redirect_to admin_themes_path
        else
          flash[:error] = I18n.t('spree.admin.themes.destroy.failure', name: @theme.name, errors: @theme.errors.full_messages.join(', '))
          render :index
        end
      end

      private

      def theme_params
        return {} unless params[:theme]
        params.require(:theme).permit(:template_file)
      end

      def load_themes
        @search = Spree::Theme.search(params[:q])
        @themes = @search.result.order(:name).page(params[:page]).per(params[:per_page])
      end

      def load_theme
        @theme = Spree::Theme.find_by(id: params[:id])
        redirect_to admin_themes_path unless @theme
      end
    end
  end
end
