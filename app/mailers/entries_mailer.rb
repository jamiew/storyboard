class EntriesMailer < Merb::MailController
  def invite
    @entry = params[:entry]
    body = "http://localhost:4001/entries/#{@entry.identifier}"
    render_mail #:html => body, :text => body
  end
end