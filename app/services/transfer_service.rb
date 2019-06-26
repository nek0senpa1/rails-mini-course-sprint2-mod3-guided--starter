class TransferService
  class TransferError < StandardError
  end

  attr_reader :sender, :receiver, :amount, :transfer_uid

  def initialize(sender, receiver, amount)
    @sender = sender
    @receiver = receiver
    @amount = amount.to_i
    @transfer_uid = SecureRandom.uuid
  end

  def process!
    raise TransferError, "Unable to initiate transfer: invalid amount" unless valid_transfer?

    deposit = receiver.deposit(amount, transfer_uid)
    withdrawal = sender.withdrawal(amount, transfer_uid)

    if deposit.present? && withdrawal.present?
      ProcessTransfersJob.perform_async(transfer_uid)
      return withdrawal
    else
      raise TransferError, "Unable to initiate transfer: uknown error"
    end
  end

  private

  def valid_transfer?
    valid_amount? && enough_funds_for_transfer?
  end

  def valid_amount?
    amount.is_a?(Integer) && amount > 0
  end

  def enough_funds_for_transfer?
    sender.balance >= amount
  end
end
