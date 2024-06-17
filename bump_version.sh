#!/bin/bash

# Obtém a branch atual
BRANCH_NAME=$(git symbolic-ref --short HEAD)

# Obtém a última versão ou define a versão inicial
LAST_TAG=$(git describe --tags `git rev-list --tags --max-count=1` 2>/dev/null)
if [ -z "$LAST_TAG" ]; then
  echo "Nenhuma tag encontrada. Definindo a versão inicial para 0.1.0."
  LAST_VERSION="0.1.0"
else
  LAST_VERSION=$(echo $LAST_TAG | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
fi

# Define o tipo de versão com base na branch
if [[ "$BRANCH_NAME" == "develop" ]]; then
  # Conta o número de merges na develop para definir a versão alpha
  NUM_MERGES=$(git log --oneline --merges develop | wc -l)
  NEW_VERSION="$LAST_VERSION-alpha.$NUM_MERGES"
elif [[ "$BRANCH_NAME" == release/* ]]; then
  # Conta o número de commits na release branch para definir a versão rc.X
  NUM_COMMITS=$(git rev-list --count HEAD)
  NEW_VERSION="$LAST_VERSION-rc.$NUM_COMMITS"
elif [[ "$BRANCH_NAME" == "main" ]]; then
  # Versão final
  NEW_VERSION="$LAST_VERSION"
else
  echo "Branch desconhecida: $BRANCH_NAME"
  exit 1
fi

# Salva a nova versão no arquivo VERSION
echo $NEW_VERSION > VERSION
echo "Nova versão: $NEW_VERSION"

# Commit e tag da nova versão
git config user.email "brunourb@gmail.com"
git config user.name "Bruno Urbano Rodrigues"

git add VERSION
if git diff-index --quiet HEAD --; then
  echo "Sem mudanças a serem commitadas"
else
  git commit -m "Bump version to $NEW_VERSION"
fi

if git rev-parse "$NEW_VERSION" >/dev/null 2>&1; then
  echo "Tag $NEW_VERSION já existe"
else
  git tag $NEW_VERSION
  git push origin $BRANCH_NAME
  git push origin --tags
fi

# Limpar versões anteriores e branches desnecessárias
if [[ "$BRANCH_NAME" == "main" ]]; then
  # Apagar tags rc
  git tag -l "0.1.0-rc.*" | xargs -n 1 git tag -d
  git tag -l "0.1.0-rc.*" | xargs -n 1 -I {} git push --delete origin {}

  # Apagar branches alpha
  git branch -r | grep 'origin/develop' | awk -F/ '{print $2}' | xargs -n 1 -I {} git push --delete origin {}
fi
