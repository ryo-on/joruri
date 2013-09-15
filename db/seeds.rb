# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

def truncate(model)
  conn = model.connection()
  conn.execute("TRUNCATE TABLE #{model.table_name}")
end

def file(path)
  file = "#{Rails.root}/db/seeds/#{path}.txt"
  FileTest.exist?(file) ? File.new(file).read.force_encoding('utf-8') : nil
end

## ---------------------------------------------------------
## load config

core_uri   = Util::Config.load(:core, :uri)
core_title = Util::Config.load(:core, :title)
map_key    = Util::Config.load(:core, :map_key)
site_title = "ジョールリ市"

## ---------------------------------------------------------
## Sys

truncate Sys::Unid
truncate Sys::Sequence
truncate Sys::User
truncate Sys::Group
truncate Sys::UsersGroup

## group
Sys::Group.create(:parent_id => 0, :level_no => 1, :sort_no => 1, :state => 'enabled', :web_state => 'closed', :ldap => 0, :code => 'S001', :name_en => 'soshiki', :name => '組織')
p = Sys::Group.create(:parent_id => 1, :level_no => 2, :sort_no =>  2, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '001'   , :name_en => 'kikakubu', :name => '企画部')
  Sys::Group.create(:parent_id => p.id, :level_no => 3, :sort_no =>  1, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '001001', :name_en => 'buchoshitsu', :name => '部長室')
  Sys::Group.create(:parent_id => p.id, :level_no => 3, :sort_no =>  2, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '001002', :name_en => 'hisyokohoka', :name => '秘書広報課')
  Sys::Group.create(:parent_id => p.id, :level_no => 3, :sort_no =>  3, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '001003', :name_en => 'jinjika', :name => '人事課')
  Sys::Group.create(:parent_id => p.id, :level_no => 3, :sort_no =>  4, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '001004', :name_en => 'kikakuseisakuka', :name => '企画政策課')
  Sys::Group.create(:parent_id => p.id, :level_no => 3, :sort_no =>  5, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '001005', :name_en => 'gyoseijohoshitsu', :name => '行政情報室')
  Sys::Group.create(:parent_id => p.id, :level_no => 3, :sort_no =>  6, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '001006', :name_en => 'itsuishinka', :name => 'IT推進課')
p = Sys::Group.create(:parent_id => 1, :level_no => 2, :sort_no =>  3, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '002'   , :name_en => 'somubu', :name => '総務部')
  Sys::Group.create(:parent_id => p.id, :level_no => 3, :sort_no =>  1, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '002001', :name_en => 'buchoshitsu', :name => '部長室')
  Sys::Group.create(:parent_id => p.id, :level_no => 3, :sort_no =>  2, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '002002', :name_en => 'zaiseika', :name => '財政課')
  Sys::Group.create(:parent_id => p.id, :level_no => 3, :sort_no =>  3, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '002003', :name_en => 'chosyakensetsusuishinka', :name => '庁舎建設推進室')
  Sys::Group.create(:parent_id => p.id, :level_no => 3, :sort_no =>  4, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '002004', :name_en => 'kanzaika', :name => '管財課')
  Sys::Group.create(:parent_id => p.id, :level_no => 3, :sort_no =>  5, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '002005', :name_en => 'zeimuka', :name => '税務課')
  Sys::Group.create(:parent_id => p.id, :level_no => 3, :sort_no =>  6, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '002006', :name_en => 'nozeika', :name => '納税課')
  Sys::Group.create(:parent_id => p.id, :level_no => 3, :sort_no =>  7, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '002007', :name_en => 'shiminanzenkyoku', :name => '市民安全局')
p = Sys::Group.create(:parent_id => 1, :level_no => 2, :sort_no =>  4, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '003'   , :name_en => 'shiminbu', :name => '市民部')
p = Sys::Group.create(:parent_id => 1, :level_no => 2, :sort_no =>  5, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '004'   , :name_en => 'kankyokanribu', :name => '環境管理部')
p = Sys::Group.create(:parent_id => 1, :level_no => 2, :sort_no =>  6, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '005'   , :name_en => 'hokenhukushibu', :name => '保健福祉部')
p = Sys::Group.create(:parent_id => 1, :level_no => 2, :sort_no =>  7, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '006'   , :name_en => 'sangyobu', :name => '産業部')
p = Sys::Group.create(:parent_id => 1, :level_no => 2, :sort_no =>  8, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '007'   , :name_en => 'kensetsubu', :name => '建設部')
p = Sys::Group.create(:parent_id => 1, :level_no => 2, :sort_no =>  9, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '008'   , :name_en => 'tokuteijigyobu', :name => '特定事業部')
p = Sys::Group.create(:parent_id => 1, :level_no => 2, :sort_no => 10, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '009'   , :name_en => 'kaikei', :name => '会計')
p = Sys::Group.create(:parent_id => 1, :level_no => 2, :sort_no => 11, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '010'   , :name_en => 'suidobu', :name => '水道部')
p = Sys::Group.create(:parent_id => 1, :level_no => 2, :sort_no => 12, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '011'   , :name_en => 'kyoikuiinkai', :name => '教育委員会')
p = Sys::Group.create(:parent_id => 1, :level_no => 2, :sort_no => 13, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '012'   , :name_en => 'gikai', :name => '議会')
p = Sys::Group.create(:parent_id => 1, :level_no => 2, :sort_no => 14, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '013'   , :name_en => 'nogyoiinkai', :name => '農業委員会')
p = Sys::Group.create(:parent_id => 1, :level_no => 2, :sort_no => 15, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '014'   , :name_en => 'senkyokanriiinkai', :name => '選挙管理委員会')
p = Sys::Group.create(:parent_id => 1, :level_no => 2, :sort_no => 16, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '015'   , :name_en => 'kansaiin', :name => '監査委員')
p = Sys::Group.create(:parent_id => 1, :level_no => 2, :sort_no => 17, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '016'   , :name_en => 'koheiiinkai', :name => '公平委員会')
p = Sys::Group.create(:parent_id => 1, :level_no => 2, :sort_no => 18, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '017'   , :name_en => 'syobohonbu', :name => '消防本部')
p = Sys::Group.create(:parent_id => 1, :level_no => 2, :sort_no => 19, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '018'   , :name_en => 'jumincenter', :name => '住民センター')
p = Sys::Group.create(:parent_id => 1, :level_no => 2, :sort_no => 20, :state => 'enabled', :web_state => 'public', :ldap => 0, :code => '019'   , :name_en => 'kominkan', :name => '公民館')

## user
u1 = Sys::User.create(:state => 'enabled', :ldap => 0, :auth_no => 5, :name => 'システム管理者', :account => 'admin', :password => 'admin')
u2 = Sys::User.create(:state => 'enabled', :ldap => 0, :auth_no => 2, :name => '徳島　太郎', :account => 'user1', :password => 'user1')
u3 = Sys::User.create(:state => 'enabled', :ldap => 0, :auth_no => 5, :name => '徳島　花子', :account => 'user2', :password => 'user2')
u4 = Sys::User.create(:state => 'enabled', :ldap => 0, :auth_no => 5, :name => '吉野　三郎', :account => 'user3', :password => 'user3')

## users_group
group = Sys::Group.find_by_name_en('hisyokohoka')
Sys::UsersGroup.create(:user_id => 1, :group_id => group.id)
Sys::UsersGroup.create(:user_id => 2, :group_id => group.id)
Sys::UsersGroup.create(:user_id => 3, :group_id => group.id)
Sys::UsersGroup.create(:user_id => 4, :group_id => group.id)

## current_user
Core.user       = Sys::User.find_by_account('admin')
Core.user_group = Core.user.groups[0]

## language
truncate Sys::Language
Sys::Language.create(:state => 'enabled', :sort_no => 1, :name => 'japanese', :title => '日本語')


## ---------------------------------------------------------
## Cms

## site
truncate Cms::Site
site = Cms::Site.create(:state => 'public', :name => site_title, :full_uri => core_uri, :node_id => 1, :map_key => map_key)

## concept
truncate Cms::Concept
def create(site, parent_id, level_no, sort_no, name)
  Cms::Concept.create(:site_id => site.id, :parent_id => parent_id, :level_no => level_no, :sort_no => sort_no, :state => 'public', :name => name)
end
c_site  = create(site, 0, 1, 1  , 'ジョールリ市')
c_top   = create(site, 1, 2, 10 , 'トップページ')
#c_doc   = create(site, 1, 2, 20 , 'ホームページ記事')
c_mayor = create(site, 1, 2, 30 , '市長室')
c_unit  = create(site, 1, 2, 100, '組織')
c_cate  = create(site, 1, 2, 200, '分野')
c_attr  = create(site, 1, 2, 300, '属性')
c_area  = create(site, 1, 2, 400, '地域')

## content
truncate Cms::Content
doc = Cms::Content.create(:site_id => site.id, :concept_id => c_site.id, :state => 'public', :model => 'Article::Doc', :name => 'ホームページ記事')

## layout
truncate Cms::Layout
def create(site, concept, name, title)
  Cms::Layout.create(:site_id => site.id, :concept_id => concept.id, :state => 'public',
    :name => name, :title => title, :head => file("layouts/#{name}/head"), :body => file("layouts/#{name}/body"), :mobile_head => file("layouts/#{name}/m_head"), :mobile_body => file("layouts/#{name}/m_body"))
end
l_top      = create(site, c_top  , 'top'          , 'トップページ')
l_event    = create(site, c_site , 'event'        , 'イベント')
l_doc      = create(site, c_site , 'doc'          , '記事ページ')
l_recent   = create(site, c_site , 'recent'       , '新着記事')
l_tag      = create(site, c_site , 'tag'          , 'タグ検索')
l_map      = create(site, c_site , 'sitemap'      , 'サイトマップ')
l_unit_top = create(site, c_unit , 'unit-top'     , '組織TOP')
l_unit     = create(site, c_unit , 'unit'         , '組織')
l_cate_top = create(site, c_cate , 'category-top' , '分野TOP')
l_cate     = create(site, c_cate , 'category'     , '分野')
l_attr_top = create(site, c_attr , 'attribute-top', '属性TOP')
l_attr     = create(site, c_attr , 'attribute'    , '属性')
l_area_top = create(site, c_area , 'area-top'     , '地域TOP')
l_area     = create(site, c_area , 'area'         , '地域')
l_mayor    = create(site, c_mayor, 'mayor'        , '市長の部屋')

## piece
truncate Cms::Piece
def create(site, concept, content, model, name, title)
  content_id = content ? content.id : nil
  Cms::Piece.create(:site_id => site.id, :concept_id => concept.id, :state => 'public', :content_id => (content_id), :model => model, :name => name, :title => title, :body => file("pieces/#{name}/body"))
end
create(site, c_site, nil, 'Cms::Free'         , 'ad-lower'             , '広告（下部）')
create(site, c_site, nil, 'Cms::Free'         , 'ad-upper'             , '広告（右上部）')
create(site, c_site, nil, 'Cms::Free'         , 'address'              , '住所')
create(site, c_site, nil, 'Cms::PageTitle'    , 'page-title'           , 'ページタイトル')
create(site, c_site, nil, 'Cms::BreadCrumb'   , 'bread-crumbs'         , 'パンくず')
create(site, c_site, nil, 'Cms::Free'         , 'global-navi'          , 'グローバルナビ')
create(site, c_site, nil, 'Cms::Free'         , 'footer-navi'          , 'フッターナビ')
create(site, c_site, nil, 'Cms::Free'         , 'common-banner'        , 'サイトバナー')
create(site, c_site, nil, 'Cms::Free'         , 'common-header'        , 'ふりがな・よみあげヘッダー')
create(site, c_site, nil, 'Cms::Free'         , 'recent-docs-title'    , '新着情報タイトル')
create(site, c_site, nil, 'Cms::Free'         , 'attract-information'  , '注目情報')
create(site, c_site, nil, 'Cms::Free'         , 'relation-link'        , '関連リンク')
create(site, c_site, doc, 'Article::Unit'     , 'unit-list'            , '組織一覧')
create(site, c_site, doc, 'Article::Category' , 'category-list'        , '分野一覧')
create(site, c_site, doc, 'Article::Attribute', 'attribute-list'       , '属性一覧')
create(site, c_site, doc, 'Article::Area'     , 'area-list'            , '地域一覧')
create(site, c_site, doc, 'Article::Calendar' , 'calendar'             , 'カレンダー')
create(site, c_site, doc, 'Article::RecentDoc', 'recent-docs'          , '新着記事')
create(site, c_top , nil, 'Cms::Free'         , 'about'                , 'ジョールリ市の紹介')
create(site, c_top , nil, 'Cms::Free'         , 'application'          , '申請書ダウンロード')
create(site, c_top , nil, 'Cms::Free'         , 'area-information'     , '地域情報')
create(site, c_top , nil, 'Cms::Free'         , 'basic-information'    , '基本情報')
create(site, c_top , nil, 'Cms::Free'         , 'common-banner-top'    , 'サイトバナー（トップ）')
create(site, c_top , nil, 'Cms::Free'         , 'mayor'                , '市長室')
create(site, c_top , nil, 'Cms::Free'         , 'qr-code'              , 'QRコード')
create(site, c_top , nil, 'Cms::Free'         , 'photo'                , 'トップ写真')
create(site, c_top , nil, 'Cms::Free'         , 'useful-information'   , 'お役立ち情報')
create(site, c_area, nil, 'Cms::Free'         , 'area-map'             , '地域マップ')
## piece/mobile
create(site, c_site, nil, 'Cms::Free'         , 'mobile-common-header' , 'モバイル：ヘッダー画像')
create(site, c_site, nil, 'Cms::Free'         , 'mobile-copyright'     , 'モバイル：コピーライト')
create(site, c_top , nil, 'Cms::Free'         , 'mobile-address'       , 'モバイル：住所')
create(site, c_top , nil, 'Cms::Free'         , 'mobile-category-list' , 'モバイル：トップ分野一覧')
create(site, c_top , nil, 'Cms::Free'         , 'mobile-footer-navi'   , 'モバイル：フッターナビ')
create(site, c_top , nil, 'Cms::Free'         , 'mobile-mayor'         , 'モバイル：ようこそ市長室へ')
create(site, c_top , nil, 'Cms::Free'         , 'mobile-menu-navi'     , 'モバイル：ナビ')
create(site, c_top , nil, 'Cms::Free'         , 'mobile-pickup'        , 'モバイル：ピックアップ')
create(site, c_top , nil, 'Cms::Free'         , 'mobile-recommend-site', 'モバイル：おすすめサイト')
create(site, c_top , nil, 'Cms::Free'         , 'mobile-search'        , 'モバイル：サイト内検索')

## node
truncate Cms::Node
def create(site, parent_id, concept, layout, content, model, name, title)
  content_id = content ? content.id : nil
  dir = model == 'Cms::Page' ? 0 : 1
  Cms::Node.create(:site_id => site.id, :parent_id => parent_id, :concept_id => concept.id, :layout_id => layout.id, :content_id => content_id,
    :state => 'public', :published_at => Time.now, :route_id => parent_id, :directory => dir, :model => model, :name => name, :title => title)
end
create(site, 0, c_site, l_top     , doc, 'Cms::Directory'    , '/'         , site_title)
create(site, 1, c_top , l_top     , doc, 'Cms::Page'         , 'index.html', site_title)
create(site, 1, c_site, l_doc     , doc, 'Article::Doc'      , 'docs'      , '記事')
create(site, 1, c_site, l_recent  , doc, 'Article::RecentDoc', 'shinchaku' , '新着情報')
create(site, 1, c_site, l_event   , doc, 'Article::EventDoc' , 'event'     , 'イベントカレンダー')
create(site, 1, c_site, l_tag     , doc, 'Article::TagDoc'   , 'tag'       , 'タグ検索')
create(site, 1, c_unit, l_unit_top, doc, 'Article::Unit'     , 'soshiki'   , '組織')
create(site, 1, c_cate, l_cate_top, doc, 'Article::Category' , 'bunya'     , '分野')
create(site, 1, c_attr, l_attr_top, doc, 'Article::Attribute', 'zokusei'   , '属性')
create(site, 1, c_area, l_area_top, doc, 'Article::Area'     , 'chiiki'    , '地域')

## ---------------------------------------------------------
## Article

## unit
Article::Unit.update_all({:layout_id => l_unit.id}, nil)

## category
truncate Article::Category
def create(parent_id, level_no, sort_no, layout, content, name, title)
  Article::Category.create(:parent_id => parent_id, :level_no => level_no, :sort_no => sort_no, :layout_id => layout.id, :content_id => content.id, :state => 'public', :name => name, :title => title)
end

p = create(0, 1, 1, l_cate, doc, 'kurashi', 'くらし')
  create(p.id, 2,  1, l_cate, doc, 'shohiseikatsu', '消費生活')
  create(p.id, 2,  2, l_cate, doc, 'shakaikoken', '社会貢献・NPO')
  create(p.id, 2,  3, l_cate, doc, 'bohan', '防犯・安全')
  create(p.id, 2,  4, l_cate, doc, 'sumai', 'すまい')
  create(p.id, 2,  5, l_cate, doc, 'jinken', '人権・男女共同参画')
  create(p.id, 2,  6, l_cate, doc, 'kankyo', '環境')
  create(p.id, 2,  7, l_cate, doc, 'zei', '税')
  create(p.id, 2,  8, l_cate, doc, 'kosodate', '子育て')
  create(p.id, 2,  9, l_cate, doc, 'passport', 'パスポート')
  create(p.id, 2, 10, l_cate, doc, 'dobutsu', '動物・ペット')
  create(p.id, 2, 11, l_cate, doc, 'recycle', 'リサイクル・廃棄物')
p = create(0, 1, 2, l_cate, doc, 'fukushi', '健康・福祉')
  create(p.id, 2, 1, l_cate, doc, 'kenkou', '健康')
  create(p.id, 2, 2, l_cate, doc, 'iryo', '医療')
  create(p.id, 2, 3, l_cate, doc, 'koreisha', '高齢者・介護')
  create(p.id, 2, 4, l_cate, doc, 'chikifukushi', '地域福祉')
  create(p.id, 2, 5, l_cate, doc, 'shogaifukushi', '障害福祉')
p = create(0, 1, 3, l_cate, doc, 'kyoikubunka', '教育・文化')
  create(p.id, 2, 1, l_cate, doc, 'kyoiku', '教育')
  create(p.id, 2, 2, l_cate, doc, 'bunka', '文化・スポーツ')
  create(p.id, 2, 3, l_cate, doc, 'seishonen', '青少年')
  create(p.id, 2, 4, l_cate, doc, 'shogaigakushu', '障害学習')
  create(p.id, 2, 5, l_cate, doc, 'gakko', '学校・文化施設')
  create(p.id, 2, 6, l_cate, doc, 'kokusaikoryu', '国際交流')
p = create(0, 1, 4, l_cate, doc, 'kanko', '観光・魅力')
  create(p.id, 2, 1, l_cate, doc, 'event', '観光・イベント')
  create(p.id, 2, 2, l_cate, doc, 'meisho', '名所・景観')
  create(p.id, 2, 3, l_cate, doc, 'bussanhin', '物産品')
  create(p.id, 2, 4, l_cate, doc, 'taikenspot', '体験スポット')
p = create(0, 1, 5, l_cate, doc, 'sangyoshigoto', '産業・しごと')
  create(p.id, 2,  1, l_cate, doc, 'shigoto', '産業・しごと')
  create(p.id, 2,  2, l_cate, doc, 'koyo', '雇用・労働')
  create(p.id, 2,  3, l_cate, doc, 'shogyo', '商業・サービス業')
  create(p.id, 2,  4, l_cate, doc, 'kigyoshien', '企業支援・企業立地')
  create(p.id, 2,  5, l_cate, doc, 'shigen', '資源・エネルギー')
  create(p.id, 2,  6, l_cate, doc, 'johotsushin', '情報通信・研究開発・科学技術')
  create(p.id, 2,  7, l_cate, doc, 'kenchiku', '建築・土木')
  create(p.id, 2,  8, l_cate, doc, 'shikaku', '資格・免許・研修')
  create(p.id, 2,  9, l_cate, doc, 'sangyo', '産業')
  create(p.id, 2, 10, l_cate, doc, 'kigyo', '起業')
  create(p.id, 2, 11, l_cate, doc, 'ujiturn', 'UJIターン')
  create(p.id, 2, 12, l_cate, doc, 'chikikeizai', '地域経済')
p = create(0, 1, 6, l_cate, doc, 'gyoseimachizukuri', '行政・まちづくり')
  create(p.id, 2,  1, l_cate, doc, 'gyosei', '行政・まちづくり')
  create(p.id, 2,  2, l_cate, doc, 'koho', '広報・公聴')
  create(p.id, 2,  3, l_cate, doc, 'gyoseikaikaku', '行政改革')
  create(p.id, 2,  4, l_cate, doc, 'kengikai', '県議会・選挙')
  create(p.id, 2,  5, l_cate, doc, 'zaisei', '財政・宝くじ')
  create(p.id, 2,  6, l_cate, doc, 'shingikai', '審議会')
  create(p.id, 2,  7, l_cate, doc, 'tokei', '統計・監査')
  create(p.id, 2,  8, l_cate, doc, 'jorei', '条例・規則')
  create(p.id, 2,  9, l_cate, doc, 'soshiki', '組織')
  create(p.id, 2, 10, l_cate, doc, 'jinji', '人事・採用')
  create(p.id, 2, 11, l_cate, doc, 'nyusatsu', '入札・調達')
  create(p.id, 2, 12, l_cate, doc, 'machizukuri', 'まちづくり・都市計画')
  create(p.id, 2, 13, l_cate, doc, 'doro', '道路・施設')
  create(p.id, 2, 14, l_cate, doc, 'kasen', '河川・砂防')
  create(p.id, 2, 15, l_cate, doc, 'kuko', '空港・港湾')
  create(p.id, 2, 16, l_cate, doc, 'denki', '電気・水道')
  create(p.id, 2, 17, l_cate, doc, 'ikem', '意見・募集')
  create(p.id, 2, 18, l_cate, doc, 'johokokai', '情報公開・個人情報保護')
  create(p.id, 2, 19, l_cate, doc, 'johoka', '情報化')
  create(p.id, 2, 20, l_cate, doc, 'shinsei', '申請・届出・行政サービス')
  create(p.id, 2, 21, l_cate, doc, 'kokyojigyo', '公共事業・公営企業')
p = create(0, 1, 7, l_cate, doc, 'bosaigai', '防災')
  create(p.id, 2, 1, l_cate, doc, 'bosai', '防災')
  create(p.id, 2, 2, l_cate, doc, 'saigai', '災害')
  create(p.id, 2, 3, l_cate, doc, 'kishojoho', '気象情報')
  create(p.id, 2, 4, l_cate, doc, 'kotsu', '交通')
  create(p.id, 2, 5, l_cate, doc, 'shokunoanzen', '食の安全')

## attribute
truncate Article::Attribute
def create(sort_no, layout, content, name, title)
  Article::Attribute.create(:sort_no => sort_no, :layout_id => layout.id, :content_id => content.id, :state => 'public', :name => name, :title => title)
end
create(1, l_attr, doc, 'nyusatsu'     , '入札・調達・売却・契約')
create(2, l_attr, doc, 'saiyo'        , '採用情報')
create(3, l_attr, doc, 'shikakushiken', '各種資格試験')
create(4, l_attr, doc, 'bosyu'        , '募集（コンクール、委員等）')
create(5, l_attr, doc, 'event'        , 'イベント情報')
create(6, l_attr, doc, 'kyoka'        , '許可・認可・届出・申請')

## area
truncate Article::Area
def create(parent_id, level_no, sort_no, layout, content, name, title)
  Article::Area.create(:parent_id => parent_id, :level_no => level_no, :sort_no => sort_no, :layout_id => layout.id, :content_id => content.id, :state => 'public', :name => name, :title => title)
end
p = create(0, 1, 1, l_area, doc, 'north', '北区')
  create(p.id, 2, 1, l_area, doc, 'yokomecho'   , '横目町')
  create(p.id, 2, 2, l_area, doc, 'wakaotokocho', '若男町')
p = create(0, 1, 2, l_area, doc, 'west', '西区')
  create(p.id, 2, 1, l_area, doc, 'sankokucho'  , '三曲町')
  create(p.id, 2, 2, l_area, doc, 'dogushicho'  , '胴串町')
p = create(0, 1, 3, l_area, doc, 'east', '東区')
  create(p.id, 2, 1, l_area, doc, 'tachiyakucho', '立役町')
  create(p.id, 2, 2, l_area, doc, 'nashiwaricho', '梨割町')
p = create(0, 1, 4, l_area, doc, 'south', '南区')
  create(p.id, 2, 1, l_area, doc, 'hikitamacho' , '引玉町')
  create(p.id, 2, 2, l_area, doc, 'besshicho'   , '別師町')

## doc
truncate Article::Doc
Article::Doc.create(:content_id => doc.id, :state => 'public', :recognized_at => Core.now, :published_at => Core.now, :language_id => 1,
  :category_ids => '5', :attribute_ids => '2', :area_ids => '11',
  :recent_state => 'visible', :list_state => 'visible', :event_state => 'visible', :event_date => Date.today,
  :title => 'ジョールリ市ホームページを公開しました。', :body => file("docs/001/body") )
