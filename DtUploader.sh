url='https://github.com/DTunnel0/DownloaderPage.git'
dependencies=(git python3 pip3 screen)

for dependence in "${dependencies[@]}"; do
    if ! command -v $dependence >/dev/null 2>&1; then
        echo "Installing $dependence..."
        apt install $dependence -y &>/dev/null
    fi
done

git clone $url &>/dev/null
cd DownloaderPage
mkdir uploads

pip3 install -r requirements.txt &>/dev/null
screen -dmS downloader python3 main.py 5001

echo "★ Instalado com sucesso! ★"
echo "🔗 URL: http://$(curl -4s https://api.ipify.org):5001"
read -p "=> Aperte ENTER para voltar ao menu"
console_menu