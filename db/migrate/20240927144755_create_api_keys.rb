# frozen_string_literal: true

class CreateApiKeys < ActiveRecord::Migration[6.1]
  def change
    create_table :api_keys do |t|
      t.string :access_token
      t.string :name

      t.timestamps
    end
    add_index :api_keys, :access_token
  end
end
