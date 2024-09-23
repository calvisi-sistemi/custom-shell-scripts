#! /bin/bash 
PACKAGES_LIST_PATH="/home/lc/.system_informations/packages"
IDENTIFIER="Automated Daily Packages Maintenance Script"

source "./package-management.sh"

mkdir -p $PACKAGES_LIST_PATH # Crea la cartella di backup se non esiste

if [ $USER != 'root' ]; then
    exit 2
fi

log_to_systemd_journal "$IDENTIFIER" echo "Aggiornamento dei pacchetti regolari..."
log_to_systemd_journal "$IDENTIFIER" update_regular_packages

log_to_systemd_journal "$IDENTIFIER" echo "Rimozione dei pacchetti orfani..."
log_to_systemd_journal "$IDENTIFIER" remove_orphan_packages

log_to_systemd_journal "$IDENTIFIER" echo "Rimozione dei pacchetti non installati dalla cache..."
log_to_systemd_journal "$IDENTIFIER" remove_not_installed_packages_from_cache

log_to_systemd_journal "$IDENTIFIER" echo "Backup lista dei pacchetti installati da AUR..."
log_to_systemd_journal "$IDENTIFIER" backup_aur_packages_list

log_to_systemd_journal "$IDENTIFIER" echo "Backup lista dei pacchetti regolari..."
log_to_systemd_journal "$IDENTIFIER" backup_regular_packages_list

log_to_systemd_journal "$IDENTIFIER" echo "Impostazione dei permessi corretti per le liste di pacchetti..."
log_to_systemd_journal "$IDENTIFIER" set_right_permissions_on_backup_files
