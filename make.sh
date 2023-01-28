#bash/sh

os=$(uname -s)
# Check if the operating system is Ubuntu
if [ "$os" == "Darwin" ]; then
    is_defacto=$(ifconfig|grep 10.254.254.254)
    if [ "$is_defacto" != "" ]; then
      echo "de-facto OK"
    else
         # De-facto Ip to make xdebug work.
      sudo curl -o /Library/LaunchDaemons/com.ralphschindler.docker_10254_alias.plist https://gist.githubusercontent.com/ralphschindler/535dc5916ccbd06f53c1b0ee5a868c93/raw/com.ralphschindler.docker_10254_alias.plist
      ifconfig lo0 alias 10.254.254.254
    fi

    hostip="10.254.254.254"
else
    # Windows/linux just need host.docker.internal
    hostip="host.docker.internal"
fi

new_config=$(sed -e "s/HOST/$hostip/g" docker/php8/config.ini)

echo "$new_config"  > docker/php8/config.ini

cp ./.env.example ./.env

