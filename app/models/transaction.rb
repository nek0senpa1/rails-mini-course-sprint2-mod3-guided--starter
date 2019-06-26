class Transaction < ApplicationRecord
  def process!
    user = User.find(user_id)
    new_balance = category == "withdrawal" ? user.balance - amount : user.balance + amount
    user.update!(balance: new_balance)
    update(status: "processed")
  end
end
