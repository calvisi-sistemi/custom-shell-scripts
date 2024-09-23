#! /bin/bash 
PACKAGES_LIST_PATH="/home/lc/.packages_list_backup"
IDENTIFIER="Automated Daily Packages Maintenance Script"

source "./package-management.sh"

mkdir -p $PACKAGES_LIST_PATH # Crea la cartella di backup se non esiste

if [ $USER != 'root' ]; then
    exit 2
fi

log_to_systemd_journal "$IDENTIFIER" update_regular_packages

log_to_systemd_journal "$IDENTIFIER" remove_orphan_packages

log_to_systemd_journal "$IDENTIFIER" remove_not_installed_packages_from_cache

log_to_systemd_journal "$IDENTIFIER" backup_aur_packages_list

log_to_systemd_journal "$IDENTIFIER" backup_regular_packages_list

log_to_systemd_journal "$IDENTIFIER" set_right_permissions_on_backup_files
