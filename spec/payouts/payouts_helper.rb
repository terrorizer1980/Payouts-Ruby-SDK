require_relative '../test_harness'
require 'securerandom'

include PaypalPayoutsSdk::Payouts

module PayoutsHelper
  class << self
    def create_payouts
      sender_batch_id = 'Test_sdk_' + SecureRandom.base64(6)
      body = {
          sender_batch_header: {
              recipient_type: 'EMAIL',
              email_message: 'SDK payouts test txn',
              note: 'Enjoy your Payout!!',
              sender_batch_id: sender_batch_id,
              email_subject: 'This is a test transaction from SDK'
          },
          items: [{
                      note: 'Your 1$ Payout!',
                      amount: {
                          currency: 'USD',
                          value: '1.00'
                      },
                      receiver: 'payout-sdk-1@paypal.com',
                      sender_item_id: 'Test_txn_1'
                  }, {
                      note: 'Your 1$ Payout!',
                      amount: {
                          currency: 'USD',
                          value: '1.00'
                      },
                      receiver: 'payout-sdk-2@paypal.com',
                      sender_item_id: 'Test_txn_2'
                  }, {
                      note: 'Your 1$ Payout!',
                      amount: {
                          currency: 'USD',
                          value: '1.00'
                      },
                      receiver: 'payout-sdk-3@paypal.com',
                      sender_item_id: 'Test_txn_3'
                  }, {
                      note: 'Your 1$ Payout!',
                      amount: {
                          currency: 'USD',
                          value: '1.00'
                      },
                      receiver: 'payout-sdk-4@paypal.com',
                      sender_item_id: 'Test_txn_4'
                  }, {
                      note: 'Your 1$ Payout!',
                      amount: {
                          currency: 'USD',
                          value: '1.00'
                      },
                      receiver: 'payout-sdk-5@paypal.com',
                      sender_item_id: 'Test_txn_5'
                  }]
      }
      request = PayoutsPostRequest.new()
      request.request_body(body)

      return TestHarness::client::execute(request)
    end

    def get_payouts(batch_id)
      request = PayoutsGetRequest.new(batch_id)
      request.page(1)
      request.page_size(10)
      request.total_required(true)

      return TestHarness::client::execute(request)
    end

    def get_payouts_item(item_id)
      request = PayoutsItemGetRequest.new(item_id)

      return TestHarness::client::execute(request)
    end

    def cancel_payouts_item(item_id)
      request = PayoutsItemCancelRequest.new(item_id)

      return TestHarness::client::execute(request)
    end
  end
end