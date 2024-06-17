#!/bin/bash

# Inicializando o repositório
#git init
git checkout -b develop

# Criando e mergeando uma feature branch
git checkout -b feature/initial-feature
echo "Feature Commit 1" > feature.txt
git add feature.txt
git commit -m "feat: Add initial feature"

git checkout develop
git merge --no-ff feature/initial-feature

./bump_version.sh  # Deve gerar 0.1.0-alpha.1

git branch -d feature/initial-feature

# Continuando na develop
echo "Commit 2" >> develop.txt
git add develop.txt
git commit -m "feat: Add another feature"
./bump_version.sh  # Deve gerar 0.1.0-alpha.2

# Criando uma release branch
git checkout -b release/1.0.0 develop

# Fazendo commits na release branch
echo "Release Commit 1" >> release.txt
git add release.txt
git commit -m "fix: Prepare release"
./bump_version.sh  # Deve gerar 0.1.0-rc.1

echo "Release Commit 2" >> release.txt
git add release.txt
git commit -m "fix: Prepare release"
./bump_version.sh  # Deve gerar 0.1.0-rc.2

echo "Release Commit 3" >> release.txt
git add release.txt
git commit -m "chore: Prepare release"
./bump_version.sh  # Deve gerar 0.1.0-rc.3

echo "Release Commit 4" >> release.txt
git add release.txt
git commit -m "fix: Fix issues for release"
./bump_version.sh  # Deve gerar 0.1.0-rc.4

echo "Release Commit 5" >> release.txt
git add release.txt
git commit -m "fix: Another fix for release"
./bump_version.sh  # Deve gerar 0.1.0-rc.5

# Finalizando a release e mergeando na main
git checkout main
git merge --no-ff release/1.0.0
./bump_version.sh  # Deve gerar 0.1.0
git branch -d release/1.0.0

# Apagar tags rc
git tag -l "0.1.0-rc.*" | xargs -n 1 git tag -d
git tag -l "0.1.0-rc.*" | xargs -n 1 -I {} git push --delete origin {}

# Apagar branches alpha
git branch -r | grep 'origin/develop' | awk -F/ '{print $2}' | xargs -n 1 -I {} git push --delete origin {}
