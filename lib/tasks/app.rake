task "resque:setup" => :environment

desc "Apaga todos os jobs pendentes nas filas high, normal e low"
task "resque:clear" => :environment do
  Resque.redis.del "queue:emails"
end
