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

# The above generates the following logs in Postgres:
# Feb 11 13:32:24 hp postgres[156074]: 2021-02-11 13:32:24.769 CST [156074] ERROR:  null value in column "order_id" of relation "payments" violates not-null constraint
# Feb 11 13:32:24 hp postgres[156074]: 2021-02-11 13:32:24.769 CST [156074] DETAIL:  Failing row contains (7, null).
# Feb 11 13:32:24 hp postgres[156074]: 2021-02-11 13:32:24.769 CST [156074] STATEMENT:  UPDATE "payments" SET "order_id" = NULL WHERE ("order_id" = 6)

o = Order.create
Payment.create(order_id: o.id)
# Fails with ERROR:  duplicate key value violates unique constraint "payments_order_id_index" (Sequel::UniqueConstraintViolation) DETAIL:  Key (order_id)=(2) already exists.
Payment.create(order_id: o.id)

# The above generates the following logs in Postgres:
# Feb 11 13:32:41 hp postgres[156216]: 2021-02-11 13:32:41.234 CST [156216] ERROR:  duplicate key value violates unique constraint "payments_order_id_index"
# Feb 11 13:32:41 hp postgres[156216]: 2021-02-11 13:32:41.234 CST [156216] DETAIL:  Key (order_id)=(7) already exists.
# Feb 11 13:32:41 hp postgres[156216]: 2021-02-11 13:32:41.234 CST [156216] STATEMENT:  INSERT INTO "payments" ("order_id") VALUES (7) RETURNING *

