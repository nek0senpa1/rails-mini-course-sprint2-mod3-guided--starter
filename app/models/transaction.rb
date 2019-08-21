class Transaction < ApplicationRecord

  belongs_to(:user)

  scope :withdrawals, -> { where(category: "withdrawal")}
  scope :deposits, -> { where(category: "deposit")}

  validates :amount, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :category, inclusion: { in: ["withdrawal", "deposit"]}
  validates :status, inclusion: { in: ["pending", "processed", "failed"]}
  validates :transfer_uid, presence: true



  def process!

    #not needed due to association/ belongs to
    # user = User.find(user_id)
    new_balance = category == "withdrawal" ? user.balance - amount : user.balance + amount
    user.update!(balance: new_balance)
    update(status: "processed")
  end

  def pretty_json
    {
      user: user.email,
      amount: amount,
      category: category,
      status: status,
      transfer_uid: transfer_uid,
      created_at: created_at
    }
  end

end
