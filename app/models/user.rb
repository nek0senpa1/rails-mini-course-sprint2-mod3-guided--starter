class User < ApplicationRecord
  def deposit(amount, transfer_uid)
    Transaction.create(
      user_id: id,
      transfer_uid: transfer_uid,
      amount:  amount,
      category: "deposit",
      status:  "pending",
    )
  end

  def withdrawal(amount, transfer_uid)
    Transaction.create(
      user_id: id,
      transfer_uid: transfer_uid,
      amount:  amount,
      category: "withdrawal",
      status:  "pending",
    )
  end
end
