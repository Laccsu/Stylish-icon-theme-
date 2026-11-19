#!/usr/bin/env bash

# Diretório base (usa o primeiro argumento passado ou o padrão abaixo)
BASE_DIR="${1:-/home/laccsu/Downloads/Stylish-icon-theme-/src}"
TARGET_ICON="visual-studio-code.svg"
LINK_NAME="vscodium.svg"

# Verifica se o diretório base existe
if [[ ! -d "$BASE_DIR" ]]; then
    echo "Erro: Diretório '$BASE_DIR' não encontrado."
    exit 1
fi

echo "Buscando por '$TARGET_ICON' em: $BASE_DIR"
echo "------------------------------------------------------------"

created_count=0
updated_count=0
skipped_count=0

# Busca recursivamente todos os arquivos visual-studio-code.svg
while IFS= read -r -d '' filepath; do
    dir="$(dirname "$filepath")"
    link_path="$dir/$LINK_NAME"

    if [[ -L "$link_path" ]]; then
        current_target="$(readlink "$link_path")"
        if [[ "$current_target" == "$TARGET_ICON" ]]; then
            echo "[IGNORADO] Já existe e está correto: $link_path"
            ((skipped_count++))
        else
            ln -sfn "$TARGET_ICON" "$link_path"
            echo "[ATUALIZADO] $link_path -> $TARGET_ICON (era: $current_target)"
            ((updated_count++))
        fi
    elif [[ -e "$link_path" ]]; then
        echo "[AVISO] Arquivo físico já existe (não sobrescrito): $link_path"
        ((skipped_count++))
    else
        ln -s "$TARGET_ICON" "$link_path"
        echo "[CRIADO] $link_path -> $TARGET_ICON"
        ((created_count++))
    fi
done < <(find "$BASE_DIR" -type f -name "$TARGET_ICON" -print0)

echo "------------------------------------------------------------"
echo "Resumo:"
echo "  Criados:     $created_count"
echo "  Atualizados: $updated_count"
echo "  Ignorados:   $skipped_count"