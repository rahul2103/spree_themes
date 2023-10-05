class VinsolSpreeThemesCreateThemesAndThemesTemplatesTable < ActiveRecord::Migration[5.0]
  def change
    create_table :spree_themes do |t|
      t.string :name
      t.string :state

      t.timestamps
    end

    create_table :spree_themes_templates do |t|
      t.string :name
      t.text :body
      t.string :path
      t.string :format
      t.string :locale
      t.string :handler
      t.boolean :partial, default: false
      t.references :theme, index: true, foreign_key: { to_table: :spree_themes }

      t.timestamps
    end

    add_column :spree_themes, :template_file, :string
  end
end
