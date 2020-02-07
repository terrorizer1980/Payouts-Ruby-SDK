require_relative 'create_payouts'
require_relative 'get_payouts'
require_relative 'get_payout_item'
require_relative 'cancel_payout_item'

include PayPalHttp

# Create Payouts Batch
puts "Creating Payouts Batch"
create_resp = Samples::CreatePayouts::new().create_payouts(true)
if create_resp.status_code == 201
  # Retrieve Payout batch details
  batch_id = create_resp.result.batch_header.payout_batch_id
  puts "Retrieving Payouts batch details with id: #{batch_id}"
  get_resp = Samples::GetPayouts::new().get_payouts(batch_id, true)
  if get_resp.status_code == 200
    # Retrieve Payout Item details
    item_id = get_resp.result.items[0].payout_item_id
    puts "Retrieving Payouts item detail with id: #{item_id}"
    get_item_resp = Samples::GetPayoutItem::new().get_payout_item(item_id, true)
    if get_item_resp.status_code == 200
      # Wait till batch status becomes SUCCESS to cancel an UNCLAIMED payout item - this is just for demonstration purpose
      # Defer using this while integration
      # Note: Use Webhooks to get LIVE status updates for Payouts Batch and Item
      puts "Check if all Payouts items are processed"
      var = 0
      until var == 5
        sleep 2
        get_resp = Samples::GetPayouts::new().get_payouts(batch_id, true)
        if get_resp.result.batch_header.batch_status == 'SUCCESS'
          # Cancel UNCLAIMED Payout item
          puts "Cancelling unclaimed Payouts item with id: #{item_id}"
          cancel_resp = Samples::CancelPayoutItem.new().cancel_payout_item(item_id, true)
          if cancel_resp.status_code == 200
            puts "Successfully cancelled unclaimed Payouts item with id: #{item_id}"
          else
            puts "Failed to cancel unclaimed Payouts item with id: #{item_id}"
          end
          break
        end
        var = var + 1
      end
    else
      puts "Failed to retrieve Payouts item detail with id: #{item_id}"
    end
  else
    puts "Failed to retrieve Payouts batch detail with id: #{batch_id}"
  end
else
  puts "Failed to crate Payouts batch"
end
