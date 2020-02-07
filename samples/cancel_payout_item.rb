require_relative 'paypal_client'
require_relative 'create_payouts'
require_relative 'get_payouts'

include PaypalPayoutsSdk::Payouts

module Samples
  class CancelPayoutItem

    # Cancels an UNCLAIMED payout item
    # An item can be cancelled only when the item status is UNCLAIMED and the batch status is SUCCESS
    # Upon cancelling the item status becomes RETURNED and the funds returned back to the sender
    def cancel_payout_item(item_id, debug = false)
      request = PayoutsItemCancelRequest.new(item_id)

      begin
        response = PayPalClient::client.execute(request)

        puts "Status Code:  #{response.status_code}"
        puts "Status: #{response.result.status}"
        puts "Payout Item Id: #{response.result.payout_item_id}"
        puts "Payout Item Status: #{response.result.transaction_status}"
        puts "Links: "
        for link in response.result.links
          # this could also be called as link.rel or link.href but as method is a reserved keyword for ruby avoid calling link.method
          puts "\t#{link["rel"]}: #{link["href"]}\tCall Type: #{link["method"]}"
        end
        puts PayPalClient::openstruct_to_hash(response.result).to_json
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