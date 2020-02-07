require_relative 'paypal_client'
require_relative 'create_payouts'
require_relative 'get_payouts'

include PaypalPayoutsSdk::Payouts

module Samples
  class GetPayoutItem

    # Retrieves the details of an individual Payout item provided the item_id
    def get_payout_item(item_id, debug = false)
      request = PayoutsItemGetRequest.new(item_id)

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

# This is the driver function which invokes the get_payout_item function to retrieve a Payout Item
if __FILE__ == $0
  batch_id = Samples::CreatePayouts::new().create_payouts(true).result.batch_header.payout_batch_id
  id = Samples::GetPayouts::new().get_payouts(batch_id, true).result.items[0].payout_item_id
  Samples::GetPayoutItem::new().get_payout_item(id, true)
end