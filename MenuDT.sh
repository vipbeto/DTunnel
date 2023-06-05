url='https://github.com/DTunnel0/DTCheckUser.git'
checkuser='https://github.com/DTunnel0/DTCheckUser/raw/master/executable/checkuser'
depends=('git' 'python3' 'pip3')

cd ~

checkuser_service() {
    local _port=$1
    local _cmd=$2

    cat <<EOF >/etc/systemd/system/checkuser.service
[Unit]
Description=CheckUser Service
After=network.target nss-lookup.target

[Service]
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=${_cmd} --port ${_port} --start
Restart=on-failure
RestartPreventExitStatus=23

[Install]
WantedBy=multi-user.target
EOF
}

function install_dependencies() {
    for depend in ${depends[@]}; do
        if ! command -v $depend &>/dev/null; then
            echo "Instalando $depend..."
            apt install lolcat -y &>/dev/null
  apt install figlet -y &>/dev/null
            sudo apt install $depend
        fi
    done
}

function install_checkuser() {
    if [[ -d DTCheckUser ]]; then
        rm -rf DTCheckUser
    fi

    echo '[*] Clonando DTCheckUser...'
    git clone $url &>/dev/null
    cd DTCheckUser
    echo '[*] Instalando DTCheckUser...'
    pip3 install -r requirements.txt &>/dev/null
    sudo python3 setup.py install &>/dev/null
    cd ..
    rm -rf DTCheckUser
    echo '[+] DTCheckUser instalado!'
}

function start_checkuser() {
    echo '[*] Iniciando DTCheckUser...'
    read -p '★ Qual porta deseja utilizar?: ' -e -i 5000 port
    checkuser_service $port $(command -v checkuser)

    systemctl daemon-reload
    systemctl enable checkuser.service
    systemctl start checkuser.service

    addr=$(curl -s icanhazip.com)
   
    clear
    figlet 'DTCHECK' | lolcat
    echo -e "╔════════════════•⊱✦⊰•════════════════╗" | lolcat
    echo '  DTCheckuser instalado com sucesso!'
    echo ''
    echo '🔗 URL: http://'$addr':'$port''
    echo ''
    echo -e "╚════════════════•⊱✦⊰•════════════════╝" | lolcat
    read -p '★ Tecle ENTER para acessar o menu.'
    console_menu
}

function start_process_install() {
    install_dependencies
    install_checkuser
    start_checkuser
}

function uninstall_checkuser() {
    echo '[*] Parando DTCheckUser...'

    systemctl stop checkuser &>/dev/null
    systemctl disable checkuser &>/dev/null
    rm -rf /etc/systemd/system/checkuser.service &>/dev/null
    systemctl daemon-reload &>/dev/null

    echo '[*] Desinstalando DTCheckUser...'
    python3 -m pip uninstall checkuser -y &>/dev/null
    python3 -m pip uninstall checkeruser -y &>/dev/null

    rm -rf $(which checkuser)
    echo '[+] DTCheckUser desinstalado!'
    read
}

function reinstall_checkuser() {
    uninstall_checkuser
    install_checkuser
    start_checkuser
}

function is_installed() {
    return $(command -v checkuser &>/dev/null)
}

function get_version() {
    if is_installed; then
        echo $(checkuser --version | cut -d ' ' -f 2)
    else
        echo '-1'
    fi
}

function change_port() {
    read -p '★ Qual porta deseja utilizar agora?: ' -e -i 5000 port
    checkuser_service $port $(command -v checkuser)

    systemctl daemon-reload
    systemctl enable checkuser.service
    systemctl start checkuser.service

    addr=$(curl -s icanhazip.com)
   
    clear
    figlet 'DTCHECK' | lolcat
    echo -e "╔════════════════•⊱✦⊰•════════════════╗" | lolcat
    echo '  Porta alterada com sucesso!'
    echo ''
    echo '  🔗 Novo URL: http://'$addr':'$port''
    echo ''
    echo -e "╚════════════════•⊱✦⊰•════════════════╝" | lolcat
    read -p '★ Tecle ENTER para acessar o menu.'
    console_menu
}

function deviceid_menu() {
 clear
    figlet 'DEVICEID' | lolcat
    echo -e "╔════════════════•⊱✦⊰•════════════════╗" | lolcat
echo -e " [01] - DISPOSITIVOS POR USUARIO"
echo -e " [02] - VER TODOS DISPOSITIVOS"
echo -e " [03] - RESETAR DIPOSITIVOS DE USUARIO"
echo -e " [04] - RESETAR TUDO ⚠️"
echo -e " [00] - VOLTAR AO MENU"
echo -e "╚════════════════•⊱✦⊰•════════════════╝" | lolcat
echo
    read -p '◇ Escolha uma opção: ' option

    case $option in
    01 | 1)
    clear
    figlet 'DEVICEID' | lolcat
    echo
       read -p '◇ Por favor, digite o nome do usuario: ' seilakk
       clear
       figlet 'DEVICEID' | lolcat
        checkuser --list-devices $seilakk
        read -p 'Digite ENTER para voltar.'
        deviceid_menu
        ;;
    02 | 2)
               clear
       figlet 'DEVICEID' | lolcat
       echo
        checkuser --list-all-devices
         read -p 'Digite ENTER para voltar.'
        deviceid_menu
        ;;
    03 | 3)
        clear
    figlet 'DEVICEID' | lolcat
    echo
       read -p '◇ Por favor, digite o nome do usuario: ' seilakk
       clear
       figlet 'DEVICEID' | lolcat
        checkuser --delete-devices $seilakk
        read -p 'Digite ENTER para voltar.'
        deviceid_menu
        ;;
    04 | 4)
        rm ~/db.sqlite3
        echo 'Sucesso! Todos usuarios resetados.'
        sleep 2
        deviceid_menu
        ;;
    00 | 0)
        echo '[*] Voltando para o Menu...'
        console_menu
        ;;
    *)
        echo '[*] Opção inválida!'
        read -p 'Pressione ENTER para continuar...'
        deviceid_menu
        ;;
    esac

}

function dpage_menu() {
 clear
    figlet 'UP-PAGE' | lolcat
    echo -e "╔══════════•⊱✦⊰•══════════╗" | lolcat
echo -e " [01] - INSTALAR PAINEL"
echo -e " [02] - REINICIAR PAINEL"
echo -e " [03] - REMOVER PAINEL"
echo -e " [00] - VOLTAR AO MENU"
echo -e "╚══════════•⊱✦⊰•══════════╝" | lolcat
echo
    read -p '◇ Escolha uma opção: ' option

    case $option in
    01 | 1)
    bash <(curl -sL https://raw.githubusercontent.com/ScottBrabo/DTunnel/main/DtUploader.sh)
        ;;
    02 | 2)
    echo '[×] Reiniciando Painel...'
    sleep 2
    rm -rf downloader
              rm -rf DownloaderPage
              rm -rf DtUploader.sh
              rm -rf screen
              bash <(curl -sL https://raw.githubusercontent.com/ScottBrabo/DTunnel/main/DtUploader.sh)
        ;;
    03 | 3)
       rm -rf DownloaderPage
              rm -rf DtUploader.sh
              rm -rf screen
              echo '★ Painel removido com sucesso!'
        read -p 'Pressione ENTER para continuar...'
        console_menu
        ;;
    00 | 0)
        echo '[*] Voltando para o Menu...'
        console_menu
        ;;
    *)
        echo '[*] Opção inválida!'
        read -p 'Pressione ENTER para continuar...'
        dpage_menu
        ;;
    esac

}

function console_menu() {
    clear
  figlet 'DTCHECK' | lolcat
    echo -n ''
    if is_installed; then
        echo -e '\e[32m[INSTALADO]\e[0m - Versao:' $(get_version)
    else
        echo -e '\e[31m[DESINSTALADO]\e[0m'
    fi

    echo -e "╔════════════════•⊱✦⊰•════════════════╗" | lolcat
    echo ' [01] - INSTALAR CHECKUSER'
    echo ' [02] - REINSTALAR CHECKUSER'
    echo ' [03] - DESINSTALAR CHECKUSER'
    echo ' [04] - ALTERAR PORTA CHECKUSER'
    echo ' [05] - GERENCIAR DEVICEID'
    echo ' [06] - PAGINA UPLOADER'
    echo ' [00] - SAIR'
    echo -e "╚════════════════•⊱✦⊰•════════════════╝" | lolcat
    echo
    read -p '★ Escolha uma opção: ' option

    case $option in
    01 | 1)
        start_process_install
        console_menu
        ;;
    02 | 2)
        reinstall_checkuser
        console_menu
        ;;
    03 | 3)
        uninstall_checkuser
        console_menu
        ;;
    05 | 5)
        deviceid_menu
        ;;
        04 | 4)
        change_port
        ;;
            06 | 6)
        dpage_menu
        ;;
    00 | 0)
        echo '[*] Saindo...'
        exit 0
        ;;
    *)
        echo '[*] Opção inválida!'
        read -p 'Pressione ENTER para continuar...'
        console_menu
        ;;
    esac

}

function main() {
    case $1 in
    install | -i)
        start_process_install
        ;;
    reinstall | -r)
        reinstall_checkuser
        ;;
    uninstall | -u)
        uninstall_checkuser
        ;;
    *)
        echo "Usage: $0 [install | reinstall | uninstall]"
        exit 1
        ;;
    esac
}

if [[ $# -eq 0 ]]; then
    console_menu
else
    main $1
fi
