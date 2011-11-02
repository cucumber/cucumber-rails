module BundlerPreHelper
  def bundler
    fixture 'bundler-1.0.21.gem'
  end
  
  def bundler_pre
    fixture 'bundler-1.1.rc.gem'
  end
  
  def gem_install(path)
    run_simple("gem install #{path} --no-ri --no-rdoc")
  end

  def gem_uninstall(path)
    run_simple("gem uninstall #{path}")
  end
end

Before('@bundler-pre') do
  extend(BundlerPreHelper)
  gem_uninstall bundler
  gem_install bundler_pre
end

After('@bundler-pre') do
  gem_uninstall bundler_pre
  gem_install bundler
end
