# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:orders) do
      primary_key :id
    end

    create_table(:payments) do
      primary_key :id
      foreign_key :order_id, :orders, null: false, index: { unique: true }
    end
  end
end
