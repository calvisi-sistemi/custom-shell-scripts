# Scrivi i log nel Journal di Systemd.
# Il primo argomento è l'identificatore da usare
# Tutti gli altri sono il comando da eseguire.
function log_to_systemd_journal(){
    local NUMBER_OF_ARGUMENTS=$#
    
    if [[ $NUMBER_OF_ARGUMENTS -lt 2 ]]; then
        echo "Usage: log_to_systemd_journal IDENTIFIER COMMAND [ARGS...]"
        exit 2
    fi

    local ERROR_PRIORITY="err"
    local IDENTIFIER=$1

    # Shift to remove the IDENTIFIER from the arguments
    shift 1

    # Run the command (or shell function) and pipe stdout and stderr to systemd-cat
    {
        "$@" 2> >(systemd-cat -t "$IDENTIFIER" --stderr-priority="$ERROR_PRIORITY") | systemd-cat -t "$IDENTIFIER"
    }
}

# Prende come unico argomento il nome di un utente e restituisce la sua home directory
function get_home_directory(){

	local NUMBER_OF_ARGUMENTS=$#
	
	if [[ $NUMBER_OF_ARGUMENTS -ne 1 ]]; then
		echo "get_home_directory: Devi specificare ESATTAMENTE UN ARGOMENTO. Né più né meno"
		exit 2
	fi
	
	local USERNAME=$1

	getent passwd "$USERNAME" | awk -F: '{print $6}' # Cerco lo username nel file passwd. Uso AWK per mostrare solo il sesto campo dell'output (quello in cui si trova il percorso della home)
	
}

MACHINE_OWNER_USERNAME="lc"
MACHINE_OWNER_HOME_DIRECTORY=$(get_home_directory "$MACHINE_OWNER_USERNAME")
SYSTEM_INFO_PATH="$MACHINE_OWNER_HOME_DIRECTORY/.system_informations"
