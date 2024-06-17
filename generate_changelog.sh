#!/bin/bash

# Defina o nome do arquivo de changelog
CHANGELOG_FILE="CHANGELOG.md"

# Defina a branch específica que você deseja listar os commits
TAG_NAME=$(git describe --tags `git rev-list --tags --max-count=1`)  # Pega a tag mais recente

# Defina o URL base do repositório GitLab
REPO_URL="https://gitlab.com/username/repository"  # Substitua pelo URL do seu repositório

# Defina o caminho ou URL da imagem do logo
LOGO_URL="https://example.com/path/to/logo.png"  # Substitua pelo caminho ou URL do seu logo

# Cria ou limpa o arquivo de changelog
echo "<img src=\"$LOGO_URL\" align=\"right\" width=\"100\" style=\"margin-left: 20px;\" />" > $CHANGELOG_FILE
echo "" >> $CHANGELOG_FILE
echo "# Changelog" >> $CHANGELOG_FILE
echo "" >> $CHANGELOG_FILE

# Adiciona cabeçalhos para os tipos de commit
echo "## Features" >> $CHANGELOG_FILE
echo "" >> $CHANGELOG_FILE

# Lista os commits do tipo 'feat' associados à tag com detalhes
git log $TAG_NAME --grep='^feat' --pretty=format:"- [%h]($REPO_URL/commit/%H) **%s** (%an, %ad)" --date=format:'%d-%m-%Y' >> $CHANGELOG_FILE

echo "" >> $CHANGELOG_FILE
echo "## Fixes" >> $CHANGELOG_FILE
echo "" >> $CHANGELOG_FILE

# Lista os commits do tipo 'fix' associados à tag com detalhes
git log $TAG_NAME --grep='^fix' --pretty=format:"- [%h]($REPO_URL/commit/%H) **%s** (%an, %ad)" --date=format:'%d-%m-%Y' >> $CHANGELOG_FILE

echo "" >> $CHANGELOG_FILE
echo "## Chores" >> $CHANGELOG_FILE
echo "" >> $CHANGELOG_FILE

# Lista os commits do tipo 'chore' associados à tag com detalhes
git log $TAG_NAME --grep='^chore' --pretty=format:"- [%h]($REPO_URL/commit/%H) **%s** (%an, %ad)" --date=format:'%d-%m-%Y' >> $CHANGELOG_FILE

# Adicione seções adicionais conforme necessário, como 'refactor', 'docs', 'style', etc.
echo "" >> $CHANGELOG_FILE
echo "## Refactors" >> $CHANGELOG_FILE
echo "" >> $CHANGELOG_FILE

# Lista os commits do tipo 'refactor' associados à tag com detalhes
git log $TAG_NAME --grep='^refactor' --pretty=format:"- [%h]($REPO_URL/commit/%H) **%s** (%an, %ad)" --date=format:'%d-%m-%Y' >> $CHANGELOG_FILE

echo "" >> $CHANGELOG_FILE
echo "## Documentation" >> $CHANGELOG_FILE
echo "" >> $CHANGELOG_FILE

# Lista os commits do tipo 'docs' associados à tag com detalhes
git log $TAG_NAME --grep='^docs' --pretty=format:"- [%h]($REPO_URL/commit/%H) **%s** (%an, %ad)" --date=format:'%d-%m-%Y' >> $CHANGELOG_FILE

echo "" >> $CHANGELOG_FILE
echo "## Styles" >> $CHANGELOG_FILE
echo "" >> $CHANGELOG_FILE

# Lista os commits do tipo 'style' associados à tag com detalhes
git log $TAG_NAME --grep='^style' --pretty=format:"- [%h]($REPO_URL/commit/%H) **%s** (%an, %ad)" --date=format:'%d-%m-%Y' >> $CHANGELOG_FILE

echo "" >> $CHANGELOG_FILE
echo "## Tests" >> $CHANGELOG_FILE
echo "" >> $CHANGELOG_FILE

# Lista os commits do tipo 'test' associados à tag com detalhes
git log $TAG_NAME --grep='^test' --pretty=format:"- [%h]($REPO_URL/commit/%H) **%s** (%an, %ad)" --date=format:'%d-%m-%Y' >> $CHANGELOG_FILE

echo "" >> $CHANGELOG_FILE
echo "## Other" >> $CHANGELOG_FILE
echo "" >> $CHANGELOG_FILE

# Lista os commits que não se enquadram nas categorias acima
git log $TAG_NAME --invert-grep --grep='^feat\|^fix\|^chore\|^refactor\|^docs\|^style\|^test' --pretty=format:"- [%h]($REPO_URL/commit/%H) **%s** (%an, %ad)" --date=format:'%d-%m-%Y' >> $CHANGELOG_FILE

echo "Changelog gerado com sucesso no arquivo $CHANGELOG_FILE"
