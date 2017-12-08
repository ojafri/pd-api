param(
  [parameter(mandatory=$true)] [validateNotNullOrEmpty()] [string]$work,
  [parameter(mandatory=$true)] [validateNotNullOrEmpty()] [string]$node,
  [parameter(mandatory=$true)] [validateNotNullOrEmpty()] [string]$env,
  [parameter(mandatory=$true)] [validateNotNullOrEmpty()] [string]$app,
  [string]$pool
)

echo "work=$work, node=$node, env=$env, app=$app, pool=$pool"

invoke-command -computerName "$node" -scriptBlock { whoami }

if ($pool) {
  invoke-command -computerName "$node" -scriptBlock { stop-webAppPool -name "$pool" }
}

set remote \\$node\Applications\$app-$env

echo "contents of [$work]"
ls $work

echo "contents of [$remote]"
ls $remote

remove-item $remote\dist -force -recurse
copy-item $work\dist -destination $remote -force -recurse

remove-item $remote\node_modules -force -recurse
copy-item $work\node_modules -destination $remote -force -recurse

remove-item $remote\config -force -recurse
copy-item $work\config -destination $remote -force -recurse

copy-item $work\iis-config\web.config -destination $remote -force
copy-item $work\iis-config\appSettings.$env.config -destination $remote\appSettings.config -force
# copy-item $work\iis-config\iisnode.$env.yml -destination $remote\iisnode.yml -force

copy-item $work\package.json -destination $remote -force
copy-item $work\git.json -destination $remote -force

if ($pool) {
  invoke-command -computerName "$node" -scriptBlock { start-webAppPool -name "$pool" }
}
