class ReceiptMailer < SuperMailer


  def receipt_email( receipt, pdf )
    @user = receipt.user
    email = fetch_email receipt
    attachments[receipt.filename] = pdf

    m = mail(:to => email, :subject => "Receipt - #{receipt.receipt_nr}") do |format|
      format.html{ render layout: 'email_html_layout' }
    end
    set_from( m )
  end


  private


    def fetch_email receipt
      return receipt.email if !receipt.email.to_s.empty?
      return receipt.user.email
    end


end
