# encoding: utf-8

#load "#{Rails.root}/db/seed/demo.rb"
#load "#{Rails.root}/db/seeds_demo_multi.rb" # self

multi_num = 23

## ---------------------------------------------------------
## sys/user

group = Sys::Group.find_by_name_en('hisyokohoka')
4.upto(multi_num) do |i|
  user  = Sys::User.create :state => 'enabled', :ldap => 0, :auth_no => 5,
    :name => "User#{i}", :account => "user#{i}", :password => "user#{i}"
  Sys::UsersGroup.create :user_id => user.id, :group_id => group.id
  #role = Sys::RoleName.create :name => 'common', :title => '一般ユーザ'
  #Sys::ObjectPrivilege.create :role_id => role.id, :item_unid => c_site.unid, :action => 'read'
end

## ---------------------------------------------------------
## demo/multi

@base_site    = Cms::Site.find(:first)
@base_article = Cms::Content.find(:first, :conditions => "model = 'Article::Doc'")
@base_portal  = Cms::Content.find(:first, :conditions => "model = 'Portal::Feed'")

create_site_data = Proc.new do |site_name, site_uri|

  ## cms/site
  site = Cms::Site.create :state => 'public', :name => site_name, :full_uri => site_uri, :node_id => 1
  
  ## cms/concept
  concept_total = Cms::Concept.count()
  #base_count  = Cms::Concept.count("site_id = #{@base_site.id}")
  Cms::Concept.find(:all, :conditions => "site_id = #{@base_site.id}").each do |base|
    item            = Cms::Concept.new(base.attributes)
    item.unid       = nil
    item.site_id    = site.id
    item.parent_id += concept_total if item.parent_id != 0
    item.save(false)
  end
  
  ## cms/content
  content_total = Cms::Content.count()
  Cms::Content.find(:all, :conditions => "site_id = #{@base_site.id}").each do |base|
    item             = Cms::Content.new(base.attributes)
    item.unid        = nil
    item.site_id     = site.id
    item.concept_id += concept_total
    item.save(false)
    
    base.settings.each do |setting|
      si = Cms::ContentSetting.new(setting.attributes)
      si.content_id += content_total
      si.value       = si.value.to_i + content_total if si.name =~ /content_id$/
      si.save(false)
    end
  end
  
  ## cms/layout
  layout_total = Cms::Layout.count()
  Cms::Layout.find(:all, :conditions => "site_id = #{@base_site.id}").each do |base|
    item             = Cms::Layout.new(base.attributes)
    item.unid        = nil
    item.site_id     = site.id
    item.concept_id += concept_total
    item.save(false)
  end
  
  ## cms/piece
  piece_total = Cms::Piece.count()
  Cms::Piece.find(:all, :conditions => "site_id = #{@base_site.id}").each do |base|
    item             = Cms::Piece.new(base.attributes)
    item.unid        = nil
    item.site_id     = site.id
    item.concept_id += concept_total
    item.content_id += content_total if item.content_id.to_i > 0
    item.save(false)
  end
  
  ## cms/nodes
  node_total = Cms::Node.count()
  Cms::Node.find(:all, :conditions => "site_id = #{@base_site.id}").each do |base|
    item             = Cms::Node.new(base.attributes)
    item.unid        = nil
    item.site_id     = site.id
    item.concept_id += concept_total if item.concept_id.to_i > 0
    item.parent_id  += node_total    if item.parent_id.to_i > 0
    item.route_id   += node_total    if item.route_id.to_i > 0
    item.content_id += content_total if item.content_id.to_i > 0
    item.layout_id  += layout_total  if item.layout_id.to_i > 0
    item.save(false)
  end
  site.node_id += node_total
  site.save(false)
  
  ## article/category
  category_total = Article::Category.count()
  Article::Category.find(:all, :conditions => "content_id = #{@base_article.id}").each do |base|
    item             = Article::Category.new(base.attributes)
    item.unid        = nil
    item.concept_id += concept_total  if item.concept_id.to_i > 0
    item.parent_id  += category_total if item.parent_id.to_i > 0
    item.content_id += content_total  if item.content_id.to_i > 0
    item.layout_id  += layout_total   if item.layout_id.to_i > 0
    item.save(false)
  end
  
  ## article/attribute
  attribute_total = Article::Attribute.count()
  Article::Attribute.find(:all, :conditions => "content_id = #{@base_article.id}").each do |base|
    item             = Article::Attribute.new(base.attributes)
    item.unid        = nil
    item.concept_id += concept_total if item.concept_id.to_i > 0
    item.content_id += content_total if item.content_id.to_i > 0
    item.layout_id  += layout_total  if item.layout_id.to_i > 0
    item.save(false)
  end
  
  ## article/area
  area_total = Article::Area.count()
  Article::Area.find(:all, :conditions => "content_id = #{@base_article.id}").each do |base|
    item             = Article::Area.new(base.attributes)
    item.unid        = nil
    item.concept_id += concept_total  if item.concept_id.to_i > 0
    item.parent_id  += area_total     if item.parent_id.to_i > 0
    item.content_id += content_total  if item.content_id.to_i > 0
    item.layout_id  += layout_total   if item.layout_id.to_i > 0
    item.save(false)
  end
  
  ## article/docs
  1.upto(10) do |doc_i|
    doc = Article::Doc.new(
      :content_id    => @base_article.id + content_total,
      :state         => 'public',
      :recognized_at => Core.now,
      :published_at  => Core.now,
      :language_id   => 1,
      :category_ids  => nil,
      :attribute_ids => nil,
      :area_ids      => nil,
      :rel_doc_ids   => nil,
      :recent_state  => 'visible',
      :list_state    => 'visible',
      :event_state   => 'visible',
      :event_date    => nil,
      :title         => "記事#{doc_i}",
      :body          => ("○"*20)
    )
    doc.save(false)
  end
  
  ## portal/category
  p_category_total = Portal::Category.count()
  Portal::Category.find(:all, :conditions => "content_id = #{@base_portal.id}").each do |base|
    item             = Portal::Category.new(base.attributes)
    item.unid        = nil
    item.parent_id  += p_category_total if item.parent_id.to_i > 0
    item.content_id += content_total    if item.content_id.to_i > 0
    item.layout_id  += layout_total     if item.layout_id.to_i > 0
    item.save(false)
  end
  
end

create_site_data.call("Demo01", "http://demo01.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shTbwDz0oPppdmZC_3i7_gpU7SwaKxTMDbCny3FvjES6_Z60uQVVTZjWPQ")
create_site_data.call("Demo02", "http://demo02.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shTSiKiyGFpcKTiTMfVnolCORZIsyhQIneHSzdgPJZOx2o4JPRbt9AwvqQ")
create_site_data.call("Demo03", "http://demo03.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shSTYU2pASugPbr7Po4yHn4wVxfQNBT6opOSSAxCZcbutB_FTSoE8LS8KQ")
create_site_data.call("Demo04", "http://demo04.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shSEkKyHhCbAwzczd5nvBPfZkWHWARRj-6NeTMQxjcA4lCUIEJh5XaTyDw")
create_site_data.call("Demo05", "http://demo05.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shQyimCjJS128nR00jnXvG9dkuLKuhSxk3Qyf6vbYGgdONWeU9Q8UFNPAw")
create_site_data.call("Demo06", "http://demo06.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shTMrTIdg0Zes9p5wRA_v1ie-8eciRSOnJstfQYVmzHXEABdfFiUbf39vg")
create_site_data.call("Demo07", "http://demo07.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shQmmqB147yccJ6m2Mib3wnKcAcQmxTAZJWY0DppQ_sCJLz-hPTHP5qJBg")
create_site_data.call("Demo08", "http://demo08.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shRK5O63DLKqkYjd4CHDVxsNpr06PhT69yY4g-JRvTw5vo2vHK493Y9IKg")
create_site_data.call("Demo09", "http://demo09.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shS429PKisTo1Vj_FvgoB39YwTBKXxTQ-VkBertWpu1a6HfWVELHWIvzCA")
create_site_data.call("Demo10", "http://demo10.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shQjwiR_HCYI-RwpX8V9Cm3joEQ4KRSfYbz4bU9FTAxQzHlY1iuw3jHpXw")
create_site_data.call("Demo11", "http://demo11.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shREclDY72j1WrhYGg8AmXsElWVcuRSZ45wtfMW_YQSCjj6OgWF0hAy4Ww")
create_site_data.call("Demo12", "http://demo12.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shRFLYRK8UnM0ohZfi9LHvC4c7nLexQqEL4KGKBgCgZZ0AHGPM9BXF6QnA")
create_site_data.call("Demo13", "http://demo13.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shSGFJTzmxJRv3Rvv_prcK4wbsyQ1BTNSb6gU7idrCEEIXVA7sZW7z3OKA")
create_site_data.call("Demo14", "http://demo14.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shSCUPcGkwJowKsXG9l_Vip9x3w7KBTbmDEE37QMsosoEo1xADnP6RRSxA")
create_site_data.call("Demo15", "http://demo15.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shStVVJqKO1zugwR_RxdL1jX9YixtxQ1rDgeRpyojU5Egyp-M9YOLVZO8Q")
create_site_data.call("Demo16", "http://demo16.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shT8zPz3NdkxeQd9f3EhrEPkVuWpyxRp4f3pZDHnZmlho1ptg9X-8B6ucw")
create_site_data.call("Demo17", "http://demo17.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shTf5_XYIEd_9mbkrV04SxFBW5LkBxRrfwALu2fb7C3fvt15-p74cTA4dg")
create_site_data.call("Demo18", "http://demo18.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shT8R5n6E-Z_ykMWlwkUboEzfz3h4xTG-01cER5S3cspnuLys8AX4FNGpw")
create_site_data.call("Demo19", "http://demo19.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shSfBW2zhas2meMPC-tuLyni3PLDzBT9a110lshzo8-KCoTo_MJnOCe_LA")
create_site_data.call("Demo20", "http://demo20.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shTP1bYrH14EGLMKf2DltILvNtWdexQ5d4wgHrlGP2v5Br2HE1w4UBc_Yw")
create_site_data.call("Demo21", "http://demo21.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shT_RY5UlHuJczBq-pzpkf50wZ9GsRSMQohlhUtI7jkVYIt9KHywO39NFg")
create_site_data.call("Demo22", "http://demo22.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shTxUrVLImk65dP5iHOxzunNfYdqRRSgGqcj7xhWPsjpki0SciYrtUVlmg")
create_site_data.call("Demo23", "http://demo23.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shS1e7igBitPfGFCh5PE1yDCmVxWwhSldDYNuumKzQOsHl4V-8rPsQ_BiA")

puts "Imported demo multi data x#{multi_num}."
