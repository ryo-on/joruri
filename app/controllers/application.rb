class ApplicationController < ActionController::Base
  include Cms::Controller::Public
  helper  FormHelper
  helper  LinkHelper
  protect_from_forgery # :secret => '1f0d667235154ecf25eaf90055d99e99'
  before_filter :initialize_application
  
  def initialize_application
    mobile_view if Page.mobile? || request.mobile?
    return false if Core.dispatched?
    return Core.dispatched
  end
  
  def skip_layout
    self.class.layout 'base'
  end
  
  def send_mail(mail_fr, mail_to, subject, message)
    return false if mail_fr.blank?
    return false if mail_to.blank?
    Sys::Lib::Mailer::Base.deliver_default(mail_fr, mail_to, subject, message)
  end
  
  def send_download
    #
  end
  
  def mobile_view
    Page.mobile = true
    def request.mobile
      Jpmobile::Mobile::Au.new(nil)
    end unless request.mobile?
  end
  
private
  def rescue_action(error)
    case error
    when ActionController::InvalidAuthenticityToken
      http_error(422, error.to_s)
    else
      super
    end
  end
  
  ## Production && local
  def rescue_action_in_public(exception)
    #exception.each{}
    http_error(500, nil)
  end
  
  def error_log(message)
    f = File.open(RAILS_ROOT + '/log/errors.log', 'a')
    f.flock(File::LOCK_EX)
    f.puts "#{Core.now} - #{message.to_s.gsub(/\n/, ' ')}"
    f.flock(File::LOCK_UN)
    f.close
    return if RAILS_ENV !~ /development/
  end
  
  def http_error(status, message = nil)
    Page.error = status
    
    ## errors.log
    if Core.mode !~ /preview/
      f = File.open(RAILS_ROOT + '/log/errors.log', 'a')
      f.flock(File::LOCK_EX)
      f.puts "#{Core.now} #{status} #{request.env['REQUEST_URI']}" +
        ', "' + message.to_s.gsub(/\n/, ' ').gsub(/"/, '""') + '"'
      f.flock(File::LOCK_UN)
      f.close
    end
    
    ## Render
    file = "#{Rails.public_path}/500.html"
    if Page.site && FileTest.exist?("#{Page.site.public_path}/#{status}.html")
      file = "#{Page.site.public_path}/#{status}.html"
    elsif Core.site && FileTest.exist?("#{Core.site.public_path}/#{status}.html")
      file = "#{Core.site.public_path}/#{status}.html"
    elsif FileTest.exist?("#{Rails.public_path}/#{status}.html")
      file = "#{Rails.public_path}/#{status}.html"
    end
    
    @message = message
    return respond_to do |format|
      #render :text => "<html><body><h1>#{message}</h1></body></html>"
      format.html { render(:status => status, :file => file) }
      format.xml  { render :xml => "<errors><error>#{status} #{message}</error></errors>" }
    end
  end
end
