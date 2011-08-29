#!/bin/bash

my_dir=$(dirname $(readlink -f "$0"))
. $my_dir/deploy.conf

set -e
target_host="$1"

if [ ! "$target_host" ]; then
    echo "Call syntax: $0 <dst_host>"
    exit 1
fi

if [ ! "$app_name" ]; then
    echo "No app name given in config!"
    exit 1
fi

src_dir=$(readlink -f "$(dirname "$(readlink -f "$0")")/..")
archive=/srv/www/rails-archive/${app_name}
target_dir="/srv/www/rails/${app_name}"

work_branch=$(git branch --no-color | grep '^\*' | cut -d ' ' -f 2-)
echo "Current work branch: '$work_branch'"
if [[ $work_branch =~ no\ branch ]]; then
    if [ $(git branch --no-color | grep "integration_work" | wc -l) -gt 0 ]; then
        git branch -D integration_work
    fi
    git checkout -b "integration_work"
    work_branch="integration_work"
fi

if [ -e ../build_number ]; then
    build_number=$(cat ../build_number)

    if [ $(git branch --no-color | grep "tmp_deploy" | wc -l) -gt 0 ]; then
        git branch -D tmp_deploy
    fi
    git branch -f tmp-deploy
    git checkout tmp-deploy
    git add ../build_number
    git commit -m "added build number"
else
    build_number="DEV"
fi

repo_revision=$(git log | head -1 | cut -f 2 -d  ' ')
short_repo_revision=$(echo $repo_revision | cut -c 1-6 )

### Complain if we deploy from svn but there still are uncommitted changes
REPO_PATH="$(readlink -f ..)/"
set +e
STATUS="`git status | grep "working directory clean"`"
if [ ! "$STATUS" ]; then
		echo "------------------------------------------------------------"
		echo "There are uncommitted changes in \"$REPO_PATH\". 
Please use \"git status $REPO_PATH\" to check what has changed and commit!"
		echo "------------------------------------------------------------"
		exit 1
fi
set -e
release_qualifier=0 
while true; do
	release_tag="release_$(date +'%Y-%m-%d')_b-${build_number}_git-${short_repo_revision}"
	if [ $release_qualifier -gt 0 ]; then
			release_tag="${release_tag}.${release_qualifier}"
	fi
	if git show-ref --tags $release_tag >/dev/null 2>/dev/null; then
			# info ok, release already exists
			(( release_qualifier++ ))
	else
			break
	fi
done	

### Export the trunk from svn to a temp dir and deploy it
### Tag release and place it into the releases base
git tag $release_tag

tmp_dir=$(mktemp -d)/$app_name
if [ $? -gt 0 ]; then
		echo "Could not create temp dir: $!" >&2
		exit 1
fi

git clone ..  $tmp_dir/
echo "tmp dir is: " $tmp_dir
cd $tmp_dir

echo $release_tag > release-tag

### Backup the previously deployed instance to 
arch_dir=${archive}/$(date +"%Y-%m-%d")
ssh $target_host "
		set +x
		mkdir -p $archive
		ext="1"
		while true; do 
			arch_dir=${arch_dir}_\$ext
			if [ \! -e \$arch_dir ]; then
				break
			fi
			(( ext++ ))
		done	
		echo \"Archive Dir: \$arch_dir\"
		rsync -av $target_dir/ \$arch_dir/
		"

### Deploy the files onto the target_host
rsync -rtv --delete --exclude .git/ $tmp_dir/ ${target_host}:${target_dir}/

ssh ${target_host} "for i in /etc/rails/${app_name}/*; do x=\$(basename \$i); ln -sf \$i ${target_dir}/config/$x; done"

set -e 
# chown environment.rb here -- passenger will run as the user that owns this file
ssh ${target_host} "mkdir -p $target_dir/log"
ssh ${target_host} "chown passenger $target_dir/log"
ssh ${target_host} "mkdir -p $target_dir/tmp"
ssh ${target_host} "chown passenger $target_dir/tmp"
ssh ${target_host} "chown passenger $target_dir/public/images/active_scaffold"
ssh ${target_host} "chown passenger $target_dir/public/javascripts/active_scaffold"
ssh ${target_host} "chown passenger $target_dir/public/stylesheets/active_scaffold"
ssh ${target_host} "chown passenger $target_dir/config/environment.rb"

# restart apache so passenger gets rebooted
ssh ${target_host} /etc/init.d/apache2 restart

cd $REPO_PATH
git push --tags 
git checkout $work_branch
if [ $build_number != "DEV" ]; then
    git branch -D tmp-deploy
fi
rm -rf $tmp_dir

