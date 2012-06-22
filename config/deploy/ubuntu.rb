namespace :ubuntu do
  namespace :aptget do
    desc "Updates apt-get package list"
    task :update, :roles => :app do
      run "sudo apt-get update"
    end

    desc "Upgrades system packages"
    task :upgrade, :roles => :app do
      run "sudo apt-get -y upgrade"
    end

    desc "Cleanup old apt-get package files"
    task :autoremove, :roles => :app do
      run "sudo apt-get -y autoremove"
    end  

    desc "Installs build essentials"
    task :make, :roles => :app do
      run "sudo apt-get -y install build-essential"
      run "sudo apt-get -y install python-software-properties"
    end  

    desc "Installs PCRE bindings"
    task :pcre, :roles => :app do
      run "sudo apt-get -y install libpcre3 libpcre3-dev"
    end

    desc "Installs git"
    task :git, :roles => :app do
      run "sudo apt-get -y install git-core"
    end
    
    desc "Installs Ruby 1.9.2"
    task :ruby, :roles => :app do
      run "sudo apt-get -y install ruby1.9.1"
      run "sudo apt-get -y install ruby1.9.1-dev"
      run "sudo echo 'export PATH=/usr/bin/ruby:$PATH' >> ~/.bashrc"
      run "sudo ln -sf /usr/bin/ruby1.9.1 /usr/bin/ruby"
    end
    
    desc "Installs SSL Dependencies"
    task :ssl, :roles => :app do
      run "sudo apt-get -y install libssl-dev"
      run "sudo apt-get -y install libcurl4-openssl-dev"
    end
    
    desc "Installs Nginx / Passenger"
    task :nginx, :roles => :app do
      run "sudo apt-get -y install zlib1g-dev"
      run "sudo gem install passenger --no-ri --no-rdoc"
      run "sudo passenger-install-nginx-module --auto-download --auto --prefix=/opt/nginx --extra-configure-flags=\"--with-http_gzip_static_module --with-http_ssl_module --with-ipv6\""
    end      

    desc "Installs LibXML Dependencies"
    task :libxml, :roles => :app do
      run "sudo apt-get -y install libxml2"
      run "sudo apt-get -y install libxml2-dev"
      run "sudo apt-get -y install libxslt1-dev"
    end

    desc "Installs Node.js"
    task :nodejs, :roles => :app do
      run "sudo add-apt-repository -y ppa:chris-lea/node.js"
      run "sudo apt-get update"    
      run "sudo apt-get -y install nodejs"
    end

    desc "Installs Rails gem"
    task :rails, :roles => :app do
      run "sudo gem install rails"
    end
  end
  
  desc "Sets default server localization"
  task :timezone, :roles => :app do
    run "locale-gen en_GB.UTF-8"
    run "sudo /usr/sbin/update-locale LANG=en_GB.UTF-8"
  end    
  
  desc "Prepares server by installing prerequsites"
  task :setup, :roles => :app do
    ubuntu.timezone
    ubuntu.aptget.update
    ubuntu.aptget.upgrade
    ubuntu.aptget.make
    ubuntu.aptget.pcre
    ubuntu.aptget.git
    ubuntu.aptget.ruby
    ubuntu.aptget.ssl
    ubuntu.aptget.nginx
    ubuntu.aptget.libxml
    ubuntu.aptget.nodejs
    ubuntu.aptget.rails
  end    
end
