#!/bin/bash
echo ""
for i in {1..8}; do
    for j in {1..2}; do
        printf -v padded_i "%02d" "$i"
        printf -v padded_j "%d" "$j"
        
        
        if [[ -f "${padded_i}_${padded_j}.lsp" ]]; then
            echo "Test ${padded_i}_${padded_j}"
            ./output < "${padded_i}_${padded_j}.lsp"
            echo "Test ${padded_i}_${padded_j}"
            ./smli < "${padded_i}_${padded_j}.lsp"
        else
            echo "File ${padded_i}_${padded_j}.lsp not found, skipping."
        fi
    done
done
