class CreatePayments < ActiveRecord::Migration[7.2]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.string :tx_ref
      t.decimal :amount
      t.string :status

      t.timestamps
    end
  end
end
