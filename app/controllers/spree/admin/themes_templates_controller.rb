module Spree
  module Admin
    class ThemesTemplatesController < Spree::Admin::BaseController
      before_action :load_theme, only: [:index, :new, :create, :edit, :update]
      before_action :load_template, only: [:edit, :update]

      def index
      end

      def new
        @template = @theme.themes_templates.build
      end

      def create
        @template = @theme.themes_templates.build(new_template_params)
        @template.created_by_admin = true

        if @template.save
          redirect_to admin_theme_templates_path(@theme)
        else
          render :new
        end
      end

      def edit
      end

      def update
        @template.update(template_params)
        render :edit
      end

      private

      def load_theme
        @theme = Spree::Theme.find_by(id: params[:theme_id])
        redirect_to admin_themes_path unless @theme
      end

      def load_template
        @template = @theme.templates.find_by(id: params[:id])
        redirect_to admin_theme_templates_path(@theme) unless @template
      end

      def template_params
        params.require(:themes_template).permit(:body)
      end

      def new_template_params
        params.require(:themes_template).permit(:body, :name, :path)
      end
    end
  end
end
