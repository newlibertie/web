#!/bin/bash

TS=$(date +%Y%m%d%H%M%S)


pushd newlibertie

rm -rf build

npm run build || exit failed to build deployable package

# create gitinfo
echo Deployed at $TS >> build/gitinfo.txt
git rev-parse HEAD >> build/gitinfo.txt
git remote -v >> build/gitinfo.txt

# create a backup of current build if exists
ssh newlibertie.com mkdir -p backups
ssh newlibertie.com mv build backups/build.until.$TS

scp -pr build newlibertie.com:  || exit failed to send build

# bounce nginx
ssh newlibertie.com sudo service nginx restart || exit failed to restart nginx

echo all done

popd


