ActionController::Routing::Routes.draw do |map|
  mod = "sys"
  
  ## script
  map.namespace(mod, :namespace => '', :path_prefix => '/_script') do |ns|
    ns.connect "run/*paths",
      :controller => "script/runner",
      :action     => :run
  end
  
  ## admin
  map.namespace(mod, :namespace => '') do |ns|
    ns.resources :maintenances,
      :controller  => "admin/maintenances",
      :path_prefix => "/_admin/#{mod}"
    ns.resources :messages,
      :controller  => "admin/messages",
      :path_prefix => "/_admin/#{mod}"
    ns.resources :languages,
      :controller  => "admin/languages",
      :path_prefix => "/_admin/#{mod}"
    ns.resources :ldap_groups,
      :controller  => "admin/ldap_groups",
      :path_prefix => "/_admin/#{mod}/:parent"
    ns.resources :ldap_users,
      :controller  => "admin/ldap_users",
      :path_prefix => "/_admin/#{mod}/:parent"
    ns.resources :users,
      :controller  => "admin/users",
      :path_prefix => "/_admin/#{mod}/:parent"
    ns.resources :groups,
      :controller  => "admin/groups",
      :path_prefix => "/_admin/#{mod}/:parent"
    ns.resources :roles,
      :controller  => "admin/roles",
      :path_prefix => "/_admin/#{mod}/:parent"
    ns.resources :inline_files,
      :controller  => "admin/inline/files",
      :path_prefix => "/_admin/#{mod}/:parent",
      :member => {:download => :get}
  end

  map.connect "_admin/#{mod}/:parent/inline_files/files/:name.:format",
    :controller => 'sys/admin/inline/files',
    :action     => 'download'
end
