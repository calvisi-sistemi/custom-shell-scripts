#! /bin/bash 

source "./general-utilities.sh"
source "./package-management.sh"

PACKAGES_LIST_PATH="$SYSTEM_INFO_PATH/packages"
IDENTIFIER="Automated Daily Packages Maintenance Script"

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

log_to_systemd_journal "$IDENTIFIER" echo "Salvataggio su GitHub delle liste di pacchetti..."
log_to_systemd_journal "$IDENTIFIER" save_packages_lists_on_github
