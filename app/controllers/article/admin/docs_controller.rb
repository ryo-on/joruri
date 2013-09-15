# encoding: utf-8
class Article::Admin::DocsController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  include Sys::Controller::Scaffold::Recognition
  include Sys::Controller::Scaffold::Publication
  helper Article::FormHelper

  def pre_dispatch
    error_auth unless @content = Cms::Content.find(params[:content])
    default_url_options :content => @content
    
    return redirect_to(request.env['PATH_INFO']) if params[:reset]
  end

  def index
    item = Article::Doc.new#.public#.readable
    item.public unless Core.user.has_auth?(:manager)
    item.and :content_id, @content.id
    item.search params
    item.page  params[:page], params[:limit]
    item.order params[:sort], 'updated_at DESC'
    @items = item.find(:all)
    _index @items
  end

  def show
    @item = Article::Doc.new.find(params[:id])
    return error_auth unless @item.readable?
    _show @item
  end

  def new
    @item = Article::Doc.new({
      :state        => 'recognize',
      :notice_state => 'hidden',
      :recent_state => 'visible',
      :list_state   => 'visible',
      :event_state  => 'hidden',
      :in_inquiry   => {'state' => 'visible'}
    })
    
    ## add tmp_id
    unless params[:_tmp]
      return redirect_to url_for(:action => :new, :_tmp => Util::Sequencer.next_id(:tmp, :md5 => true))
    end
  end

  def create
    @item = Article::Doc.new(params[:item])
    @item.content_id = @content.id
    @item.state      = params[:commit_recognize] ? 'recognize' : 'draft'

    _create @item do
      @item.fix_tmp_files(params[:_tmp])
      if @item.state == 'recognize'
        send_recognition_request_mail(@item)
      else
        @item.recognition.destroy if @item.recognition;
      end
    end
  end

  def update
    @item = Article::Doc.new.find(params[:id])
    @item.attributes = params[:item]
    @item.state      = params[:commit_recognize] ? 'recognize' : 'draft'

    _update(@item) do
      if @item.state == 'recognize'
        send_recognition_request_mail(@item)
      else
        @item.recognition.destroy if @item.recognition;
      end
      @item.close if @item.published_at
    end
  end

  def recognize(item)
    _recognize(item) do
      send_recognition_success_mail(@item) if @item.state == 'recognized'
    end
  end
  
  def destroy
    @item = Article::Doc.new.find(params[:id])
    _destroy @item
  end

protected
  def send_recognition_request_mail(item)
    mail_fr = Core.user.email
    mail_to = nil
    subject = "#{item.content.name}（#{item.content.site.name}）：承認依頼メール"
    message = "#{Core.user.name}さんより「#{item.title}」についての承認依頼が届きました。\n" +
      "次の手順により，承認作業を行ってください。\n" +
      "\n" +
      "１．PC用記事のプレビューにより文書を確認\n" +
      "　#{item.preview_uri}\n" +
      "\n" +
      "２．次のリンクから承認を実施\n" +
      "　#{url_for(:action => :show, :id => item)}\n"
    
    item.recognizers.each do |user|
      send_mail(mail_fr, user.email, subject, message)
    end
  end

  def send_recognition_success_mail(item)
    return true unless item.recognition
    return true unless item.recognition.user
    return true if item.recognition.user.email.blank?

    mail_fr = Core.user.email
    mail_to = item.recognition.user.email
    
    subject = "#{item.content.name}（#{item.content.site.name}）：最終承認完了メール"
    message = "「#{item.title}」についての承認が完了しました。\n" +
              "次のＵＲＬをクリックして公開処理を行ってください。\n" +
              "\n" +
              "#{url_for(:action => :show, :id => item)}"
    
    send_mail(mail_fr, mail_to, subject, message)
  end
end
