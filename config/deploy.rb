# storybored capistrano conf
# jamie dubs <http://tramchase.com>

set :application, "storybored"
set :repository,  "http://tramchase.com/svn/#{application}"
set :deploy_to, "/www/apps/#{application}"

role :app, "col", :primary => true
role :web, "col", :primary => true
role :db,  "col", :primary => true



# jamiew's load production data task
# based on http://push.cx/2007/capistrano-task-to-load-production-data
desc "Load production data into development database"
task :load_production_data, :roles => :db, :only => { :primary => true } do
  require 'yaml'
  ['config/database.yml'].each do |file|
    print "going to load #{file}"
    database = YAML::load_file(file)
    puts database.inspect

    filename = "/tmp/#{application}-db.#{Time.now.strftime '%Y-%m-%d-%H-%M'}.sql.gz"
    on_rollback { File.unlink(filename) }

    run "mysqldump -h #{database[:production][:host]} -u #{database[:production][:username]} --password=#{database[:production][:password]} #{database[:production][:database]} | gzip > #{filename}" do |channel, stream, data|
      puts data
    end
    get filename, filename # change if /tmp is not bueno
    password = database[:development][:password].nil? ? '' : "--password=#{database[:development][:password]}"  # FIXME shows up in process list, do not use in shared hosting    
    # exec "mysql -u #{database['development']['username']} #{password} #{database['development']['database']} < #{filename}; rm -f #{filename}"
    `gunzip -c #{filename} | mysql -u #{database[:development][:username]} #{password} #{database[:development][:database]} && rm -f gunzip #{filename}`
    File.unlink(filename)
  end
  
end
