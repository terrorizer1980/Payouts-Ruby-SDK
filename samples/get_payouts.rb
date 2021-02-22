require_relative 'paypal_client'
require_relative 'create_payouts'

include PaypalPayoutsSdk::Payouts

module Samples
  class GetPayouts

    # Retries a Payout batch details provided the batch_id
    # This API is paginated - by default 1000 payout items are retrieved
    # Use pagination links to navigate through all the items, use total_required to get the total pages
    def get_payouts(batch_id, debug = false)
      request = PayoutsGetRequest.new(batch_id)
      # Optional parameters, page_size defaults to 1000
      request.page(1)
      request.page_size(10)
      request.total_required(true)

      begin
        response = PayPalClient::client.execute(request)
        if debug
          puts "Status Code:  #{response.status_code}"
          puts "Status: #{response.result.status}"
          puts "Payout Batch ID: #{response.result.batch_header.payout_batch_id}"
          puts "Payout Batch Status: #{response.result.batch_header.batch_status}"
          puts "Items count: #{response.result.items.length}"
          puts "First item id: #{response.result.items[0].payout_item_id}"
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
        puts "Status Code: #{ioe.status_code}"
        puts "Response: #{ioe.result}"
        puts "Name: #{ioe.result.name}"
        puts "Message: #{ioe.result.message}"
        puts "Information link: #{ioe.result.information_link}"
        puts "Debug Id: #{ioe.result.debug_id}"
      end
    end
  end
end

# This is the driver function which invokes the get_payouts function to retrieve a Payouts Batch
if __FILE__ == $0
  id = Samples::CreatePayouts::new().create_payouts().result.batch_header.payout_batch_id
  Samples::GetPayouts::new().get_payouts(id, true)
  puts "Retrieve an invalid payout id"
  Samples::GetPayouts::new().get_payouts("DUMMY", true)
end