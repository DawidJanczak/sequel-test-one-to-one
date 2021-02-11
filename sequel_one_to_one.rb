# frozen_string_literal: true

require './db'

class Payment < Sequel::Model
end

class Order < Sequel::Model
  one_to_one :payment
end

o = Order.create
o.payment = Payment.new
# Fails with ERROR:  null value in column "order_id" of relation "payments" violates not-null constraint (PG::NotNullViolation) DETAIL:  Failing row contains (1, null).
o.payment = Payment.new

o = Order.create
Payment.create(order_id: o.id)
# Fails with ERROR:  duplicate key value violates unique constraint "payments_order_id_index" (Sequel::UniqueConstraintViolation) DETAIL:  Key (order_id)=(2) already exists.
Payment.create(order_id: o.id)
