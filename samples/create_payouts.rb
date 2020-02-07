require_relative 'paypal_client'
require 'securerandom'
include PaypalPayoutsSdk::Payouts

module Samples
  class CreatePayouts

    # Creates a payout batch with 5 payout items
    # Calls the create batch api (POST - /v1/payments/payouts)
    # A maximum of 15000 payout items are supported in a single batch request
    def create_payouts(debug = false)
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
                      note: 'Your 5$ Payout!',
                      amount: {
                          currency: 'USD',
                          value: '1.00'
                      },
                      receiver: 'payout-sdk-1@paypal.com',
                      sender_item_id: 'Test_txn_1'
                  }, {
                      note: 'Your 5$ Payout!',
                      amount: {
                          currency: 'USD',
                          value: '1.00'
                      },
                      receiver: 'payout-sdk-2@paypal.com',
                      sender_item_id: 'Test_txn_2'
                  }, {
                      note: 'Your 5$ Payout!',
                      amount: {
                          currency: 'USD',
                          value: '1.00'
                      },
                      receiver: 'payout-sdk-3@paypal.com',
                      sender_item_id: 'Test_txn_3'
                  }, {
                      note: 'Your 5$ Payout!',
                      amount: {
                          currency: 'USD',
                          value: '1.00'
                      },
                      receiver: 'payout-sdk-4@paypal.com',
                      sender_item_id: 'Test_txn_4'
                  }, {
                      note: 'Your 5$ Payout!',
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

      begin
        response = PayPalClient::client.execute(request)
        if debug
          puts "Status Code:  #{response.status_code}"
          puts "Status: #{response.result.status}"
          puts "Payout Batch ID: #{response.result.batch_header.payout_batch_id}"
          puts "Payout Batch Status: #{response.result.batch_header.batch_status}"
          puts "Links: "
          for link in response.result.links
            # this could also be called as link.rel or link.href but as method is a reserved keyword for ruby avoid calling link.method
            puts "\t#{link["rel"]}: #{link["href"]}\tCall Type: #{link["method"]}"
          end
          puts PayPalClient::openstruct_to_hash(response.result).to_json
        end
        return response
      rescue PayPalHttp::HttpError => ioe
        # Exception occured while processing the payouts.
        puts " Status Code: #{ioe.status_code}"
        puts " Debug Id: #{ioe.result.debug_id}"
        puts " Response: #{ioe.result}"
      end
    end

  end
end

# This is the driver function which invokes the create_payouts function to create an payouts batch.
if __FILE__ == $0
  Samples::CreatePayouts::new().create_payouts(true)
end