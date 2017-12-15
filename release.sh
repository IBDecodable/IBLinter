#!/bin/sh
# thanks to https://github.com/mono0926/LicensePlist

if [ $# -eq 1 ]; then
    echo "A tag and token argument is needed!(ex: ./release.sh 1.2.3 xxxxxxx)"
    exit 1
fi
lib_name="iblinter"
tag=$1
token=$2
export GITHUB_TOKEN=$token
echo "Tag: '${tag}'"
echo "Token: '${token}'"
filename="${tag}.tar.gz"
echo "Filename: '${filename}'"

# tag
git tag $tag
git push origin $tag

curl -LOk "https://github.com/kateinoigakukun/IBLinter/archive/${filename}"
sha256=$(shasum -a 256 $filename | cut -d ' ' -f 1)
rm $filename

echo "SHA256: '${sha256}'"
