Deface::Override.new(
  virtual_path: 'spree/admin/shared/_main_menu',
  name: 'add_themes_tab',
  insert_bottom: 'nav',
  partial: 'spree/admin/shared/theme_menu_button'
)
