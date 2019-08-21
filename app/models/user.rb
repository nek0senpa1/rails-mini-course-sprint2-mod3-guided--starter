class User < ApplicationRecord

  has_many :transactions
  
  #------------------------------

  #scope :nameofscope, -> (args) {function body}
  scope :withdrawals_for, -> (user_id) { find(user_id).transactions.withdrawals }
  scope :deposits_for, -> (user_id) { find(user_id).transactions.deposits }
  scope :transactions_for, -> (user_id) { find(user_id).transactions }


  validates :balance, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :api_key, presence: true
  validates :name, presence: true
  validates :email, uniqueness: {case_sensitive: false}, presence: true



  #------------------------------

  def deposit(amount, transfer_uid)

    # don't need because of association has many
    # Transaction.create(
      transactions.create(
      # user_id: id,
      transfer_uid: transfer_uid,
      amount:  amount,
      category: "deposit",
      status:  "pending",
    )
  end

  def withdrawal(amount, transfer_uid)
    transactions.create(
      # user_id: id,
      transfer_uid: transfer_uid,
      amount:  amount,
      category: "withdrawal",
      status:  "pending",
    )
  end
end
