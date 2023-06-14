# Get latest gem version
GEM_VERSION=$(grep -o "'.*'"  lib/flow/version.rb | tr -d "'")

# create tag based on latest gem version
TAG="v$GEM_VERSION"

# push tag / should activate push gem action
git tag $TAG
git push origin --tag

# Create a new release
gh release create $TAG --generate-notes
