# frozen_string_literal: true

# Хэш электронной почты для граватара
class AddGravatarHashToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :gravatar_hash, :string
  end
end
