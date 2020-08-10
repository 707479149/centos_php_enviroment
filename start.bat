docker rm dnmp-redis
docker rm dnmp-memcached

@echo off
for /f "tokens=4" %%a in ('route print^|findstr 0.0.0.0.*0.0.0.0') do (
 set IP=%%a
)
echo 你的局域网IP是：
echo %IP%
copy .\conf\php-base.ini  .\conf\php.ini
set a=xdebug.remote_host = "%IP%"
echo %a% >> .\conf\php.ini

docker-compose up
