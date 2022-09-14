class CreateSolidusPaypalBraintreeSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :solidus_paypal_braintree_subscriptions do |t|
      t.references :spree_order, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :payment_plan, foreign_key: { on_delete: :nullify }
      t.string :braintree_id, index: true
      t.string :braintree_plan_id
      t.string :status, index: true
      t.decimal :price
      t.decimal :balance
      t.integer :number_of_billing_cycles
      t.decimal :next_billing_period_amount
      t.date :first_billing_date, index: { name: 'index_subscriptions_on_first_billing_date'}
      t.date :next_billing_date, index: { name: 'index_subscriptions_on_next_billing_date'}
      t.boolean :trial_period
      t.integer :trial_duration
      t.string :trial_duration_unit

      t.timestamps
    end
  end
end
