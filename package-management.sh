# Aggiorno i pacchetti regolari con pacman. Non prendo argomenti in input
function update_regular_packages(){
    pacman -Syu --noconfirm
}

# Rimuovo i pacchetti orfani con pacman.  Non prendo argomenti in input
function remove_orphan_packages(){
    local orphans=$(pacman -Qdtq)
    
    if [ -n "$orphans" ]; then
        pacman --noconfirm -Rns $orphans
    fi
}

# Ripulisco la cache.  Non prendo argomenti in input
function remove_not_installed_packages_from_cache(){
    pacman -Sc --noconfirm
}

# Ottengo la lista dei pacchetti esterni ai repository regolari, ovvero, nella gran parte dei casi, i pacchetti installati da AUR
function get_aur_packages_list(){
    pacman -Qqm
}

# Ottengo la lista dei pacchetti regolari, ossia installati normalmente con pacman
function get_regular_packages_list(){
    pacman -Qqe | grep -Fxv "$(get_aur_packages_list)"
}

# Mi assicuro che i permessi delle liste di pacchetti siano impostati correttamente 
function set_right_permissions_on_backup_files(){
    chown lc:lc -R "$PACKAGES_LIST_PATH"
}

# Faccio il backup dei pacchetti regolari
function backup_regular_packages_list(){
    get_regular_packages_list > "$PACKAGES_LIST_PATH/regulars.list"
}

# Faccio il backup dei pacchetti installati da AUR
function backup_aur_packages_list(){
    get_aur_packages_list > "$PACKAGES_LIST_PATH/aur.list"
}

# Carico su GitHub le liste aggiornate
function commit_and_push_on_github(){
    local COMMIT_MESSAGE="Pacchetti installati alla data $(date)"
    git add "$PACKAGES_LIST_PATH"
    git commit -m "$COMMIT_MESSAGE"
    git push
}
