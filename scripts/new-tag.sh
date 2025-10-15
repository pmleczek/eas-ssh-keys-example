#!/bin/bash

GITHUB_REPO_URL="git@github.com:pmleczek/eas-github-ssh-private-repository.git"
GITHUB_REPO_NAME="eas-github-ssh-private-repository"

# Remove the previous checkout
if [[ -d "$GITHUB_REPO_NAME" ]]; then
  echo "Removing previous checkout of $GITHUB_REPO_NAME..."
  rm -rf "$GITHUB_REPO_NAME"
fi

# Clone the repository to the build workspace
git clone $GITHUB_REPO_URL
cd $GITHUB_REPO_NAME || { echo "Can't cd into $GITHUB_REPO_NAME"; exit 1; }

# Write current date and time to time.txt
echo $(date) > time.txt
# Write current EAS build runner to environment.txt
echo $EAS_BUILD_RUNNER > environment.txt

# Push the changes to the upstream
git add -A
git commit -m "Update time.txt and environment.txt"
echo "Pushing the changes to the upstream"
git push

# Decide on the next tag (in semver convention)
NEXT_TAG="1.0.0"
if [[ "$(git tag | wc -l)" -gt "0" ]]; then
 LAST_TAG=$(git tag --sort=-v:refname | head -n 1)
 MAJOR=$(echo "$LAST_TAG" | sed -E 's/v?([0-9]+)\..*/\1/')
 MINOR=$(echo "$LAST_TAG" | sed -E 's/v?[0-9]+\.([0-9]+)\..*/\1/')
 PATCH=$(echo "$LAST_TAG" | sed -E 's/v?[0-9]+\.[0-9]+\.([0-9]+).*/\1/')
 NEXT_PATCH=$((PATCH + 1))
 NEXT_TAG="$MAJOR.$MINOR.$NEXT_PATCH"
fi

# Create and publish new tag
echo "Creating new tag $NEXT_TAG"
git tag $NEXT_TAG -m "EAS Environment: $EAS_BUILD_RUNNER; Date: $(date)"
git push origin $NEXT_TAG

# Cleanup the repository
echo "Cleaning up the checkout of $GITHUB_REPO_NAME..."
cd ..
rm -rf $GITHUB_REPO_NAME
