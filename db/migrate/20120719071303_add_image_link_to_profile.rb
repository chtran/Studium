class AddImageLinkToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :image, :string
    add_column :profiles, :link, :string
  end
end
