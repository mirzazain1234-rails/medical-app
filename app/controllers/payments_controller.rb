class PaymentsController < ApplicationController
  require 'digest'

  def create
    product   = Product.find(params[:product_id])
    amount    = (product.price * 100).to_i.to_s.rjust(12, '0')
    txn_ref   = "TXN#{Time.now.to_i}"
    bill_ref  = "BILL#{txn_ref}"

    merchant_id    = ENV['JAZZCASH_MERCHANT_ID']
    integrity_salt = ENV['JAZZCASH_INTEGRITY_SALT']
    return_url     = ENV['JAZZCASH_RETURN_URL'] # your ngrok https callback

    txn_date    = Time.now.strftime("%Y%m%d%H%M%S")
    expiry_date = (Time.now + 1.hour).strftime("%Y%m%d%H%M%S")

    fields = {
      "pp_Version"           => "2.0",
      "pp_TxnType"           => "MWALLET",
      "pp_Language"          => "EN",
      "pp_MerchantID"        => merchant_id,
      "pp_TxnRefNo"          => txn_ref,
      "pp_Amount"            => amount,
      "pp_TxnCurrency"       => "PKR",
      "pp_TxnDateTime"       => txn_date,
      "pp_BillReference"     => bill_ref,
      "pp_Description"       => product.description.to_s.strip,
      "pp_TxnExpiryDateTime" => expiry_date,
      "pp_ReturnURL"         => return_url,
      "pp_CustomerEmail"     => current_user.email,
      "pp_MobileNumber"      => "03154507775",
      "pp_CNIC"              => "3520295479577"
    }

    # Remove nil/empty fields
    sorted_pairs = fields.reject { |_, v| v.blank? }.sort.to_h

    # Secure Hash
    hash_string  = integrity_salt + '&' + sorted_pairs.map { |k, v| "#{k}=#{v}" }.join('&')
    secure_hash  = Digest::SHA256.hexdigest(hash_string).upcase
    fields["pp_SecureHash"] = secure_hash

    # ✅ Correct merchant form URL
    jazzcash_url = "https://sandbox.jazzcash.com.pk/CustomerPortal/TransactionManagement/MerchantForm/Index.cfm"

    Rails.logger.info "JazzCash Request: #{fields.inspect}"
    Rails.logger.info "SecureHash String: #{hash_string}"

    redirect_to "#{jazzcash_url}?#{fields.to_query}", allow_other_host: true
  end
  def success
    render plain: "Payment Successful! Transaction Reference: #{params['pp_TxnRefNo']}"
  end
end
