__DIR__ = File.dirname(__FILE__)

$LOAD_PATH.unshift __DIR__ unless
  $LOAD_PATH.include?(__DIR__) ||
  $LOAD_PATH.include?(File.expand_path(__DIR__))

require "merb_approvals/spec/runner/formatter/approval_html_formatter"

if defined?(Merb::Plugins)

  $:.unshift File.dirname(__FILE__)

  dependency 'merb-slices', :immediate => true
  Merb::Plugins.add_rakefiles "merb_approvals/merbtasks", "merb_approvals/slicetasks", "merb_approvals/spectasks"

  # Register the Slice for the current host application
  Merb::Slices::register(__FILE__)
  
  # Slice configuration - set this in a before_app_loads callback.
  # By default a Slice uses its own layout, so you can swicht to 
  # the main application layout or no layout at all if needed.
  # 
  # Configuration options:
  # :layout - the layout to use; defaults to :merb_approvals
  # :mirror - which path component types to use on copy operations; defaults to all
  Merb::Slices::config[:merb_approvals][:layout] ||= :merb_approvals
  
  # All Slice code is expected to be namespaced inside a module
  module MerbApprovals
    
    # Slice metadata
    self.description = "Approvals for Merb"
    self.version = "0.0.1"
    self.author = "Sware, Inc"
    
    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally.
    def self.loaded
    end
    
    # Initialization hook - runs before AfterAppLoads BootLoader
    def self.init
    end
    
    # Activation hook - runs after AfterAppLoads BootLoader
    def self.activate
    end
    
    # Deactivation hook - triggered by Merb::Slices.deactivate(MerbApprovals)
    def self.deactivate
    end
    
    # Setup routes inside the host application
    #
    # @param scope<Merb::Router::Behaviour>
    #  Routes will be added within this scope (namespace). In fact, any 
    #  router behaviour is a valid namespace, so you can attach
    #  routes at any level of your router setup.
    #
    # @note prefix your named routes with :merb_approvals_
    #   to avoid potential conflicts with global named routes.
    def self.setup_router(scope)
      # example of a named route
      #scope.match('/index(.:format)').to(:controller => 'main', :action => 'index').name(:index)
      # the slice is mounted at /merb_approvals - note that it comes before default_routes
      scope.match('/').to(:controller => 'main', :action => 'index')
      # enable slice-level default routes by default
      scope.default_routes
    end
    
  end
  
  # Setup the slice layout for MerbApprovals
  #
  # Use MerbApprovals.push_path and MerbApprovals.push_app_path
  # to set paths to merb_approvals-level and app-level paths. Example:
  #
  # MerbApprovals.push_path(:application, MerbApprovals.root)
  # MerbApprovals.push_app_path(:application, Merb.root / 'slices' / 'merb_approvals')
  # ...
  #
  # Any component path that hasn't been set will default to MerbApprovals.root
  #
  # Or just call setup_default_structure! to setup a basic Merb MVC structure.
  MerbApprovals.setup_default_structure!
  
  # Add dependencies for other MerbApprovals classes below. Example:
  # dependency "merb_approvals/other"
  
end