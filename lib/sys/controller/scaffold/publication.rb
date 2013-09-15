# encoding: utf-8
module Sys::Controller::Scaffold::Publication

  def publish(item)
    _publish(item)
  end

  def rebuild(item)
    _rebuild(item)
  end

  def close(item)
    _close(item)
  end

protected
  def _publish(item, options = {}, &block)
    if item.publishable? && item.publish(render_public_as_string(item.public_uri, Core.site))
      flash[:notice] = options[:notice] || '公開処理が完了しました'
      yield if block_given?
      respond_to do |format|
        format.html { redirect_to url_for(:action => :index) }
        format.xml  { head :ok }
      end
    else
      flash[:notice] = "公開できません"
      respond_to do |format|
        format.html { render :action => :show }
        format.xml  { render :xml => item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def _rebuild(item, options = {}, &block)
    if item.rebuildable? && item.rebuild
      flash[:notice] = options[:notice] || '再構築処理が完了しました'
      yield if block_given?
      respond_to do |format|
        format.html { redirect_to url_for(:action => :index) }
        format.xml  { head :ok }
      end
    else
      flash[:notice] = "再構築できません"
      respond_to do |format|
        format.html { render :action => :show }
        format.xml  { render :xml => item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def _close(item, options = {}, &block)
    if item.closable? && item.close
      flash[:notice] = options[:notice] || '非公開処理が完了しました'
      yield if block_given?
      respond_to do |format|
        format.html { redirect_to url_for(:action => :index) }
        format.xml  { head :ok }
      end
    else
      flash[:notice] = "公開を終了できません"
      respond_to do |format|
        format.html { render :action => :show }
        format.xml  { render :xml => item.errors, :status => :unprocessable_entity }
      end
    end
  end
end