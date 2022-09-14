class CreateSolidusPaypalBraintreeTransaction < ActiveRecord::Migration[7.0]
  def change
    create_table :solidus_paypal_braintree_transactions do |t|
      t.references :subscription, foreign_key: { on_delete: :nullify, to_table: 'solidus_paypal_braintree_subscriptions' }, index: { name: 'index_transactions_on_subscription_id' }
      t.string :braintree_id, null: false
      t.string :braintree_subscription_id, null: false
      t.string :status, null: false
      t.string :payment_method, null: false
      t.decimal :amount, null: false

      t.timestamps
    end
    add_index :solidus_paypal_braintree_transactions, :braintree_id, name: 'index_transactions_on_braintree_id', unique: true
    add_index :solidus_paypal_braintree_transactions, :status, name: 'index_transactions_on_status'
  end
end
