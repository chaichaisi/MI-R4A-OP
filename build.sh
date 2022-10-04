REPO_URL=https://github.com/coolsnowwolf/lede
REPO_BRANCH=master
FEEDS_CONF=R4A.conf.default
CONFIG_FILE=R4A.config
DIY_P1_SH=diy-part1.sh
DIY_P2_SH=R4A.sh
DIY_P3_SH=diy-part3.sh
UPLOAD_BIN_DIR=true
UPLOAD_FIRMWARE=true
UPLOAD_COWTRANSFER=false
UPLOAD_WETRANSFER=false
UPLOAD_RELEASE=true
TZ=Asia/Shanghai

sudo rm -rf /etc/apt/sources.list.d/* /usr/share/dotnet /usr/local/lib/android /opt/ghc
sudo -E apt-get -qq update
sudo -E apt-get -qq install zip -y
sudo -E apt-get -qq install $(curl -fsSL git.io/depends-ubuntu-2004)
sudo -E apt-get -qq autoremove --purge
sudo -E apt-get -qq clean
sudo timedatectl set-timezone "$TZ"
sudo mkdir -p /workdir
sudo chown $USER:$GROUPS /workdir

df -hT $PWD
git clone $REPO_URL -b $REPO_BRANCH openwrt
ln -sf /workdir/openwrt openwrt

[ -e $FEEDS_CONF ] && mv $FEEDS_CONF openwrt/feeds.conf.default
chmod +x $DIY_P1_SH
cd openwrt
$DIY_P1_SH
cd openwrt && ./scripts/feeds update -a

cd openwrt && ./scripts/feeds install -a

[ -e files ] && mv files openwrt/files
[ -e $CONFIG_FILE ] && mv $CONFIG_FILE openwrt/.config 
chmod +x $DIY_P2_SH
cd openwrt
$DIY_P2_SH

chmod +x $DIY_P3_SH
$DIY_P3_SH

cd openwrt
make defconfig
make download -j8
find dl -size -1024c -exec ls -l {} \;
find dl -size -1024c -exec rm -f {} \;

cd openwrt
echo -e "$(nproc) thread compile"
make --trace -j$(nproc) || make --trace -j1 || make --trace -j1 V=s