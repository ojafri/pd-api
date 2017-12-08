function deploy {
  param(
    [parameter(mandatory=$true)] [validateNotNullOrEmpty()] [string]$remote,
    [parameter(mandatory=$true)] [validateNotNullOrEmpty()] [string]$local,
    [parameter(mandatory=$true)] [validateNotNullOrEmpty()] [string]$target
  )
  echo "copying [$target] from [$local] to [$remote]..."
  remove-item $remote\$target -force -recurse
  copy-item $local\$target -destination $remote -force -recurse
}
