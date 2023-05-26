REPO_URL=https://hub.fgit.ml/coolsnowwolf/lede
REPO_BRANCH=master
FEEDS_CONF=$PWD/R4A.conf.default
CONFIG_FILE=$PWD/R4A.config
DIY_P1_SH=$PWD/diy-part1.sh
DIY_P2_SH=$PWD/R4A.sh
DIY_P3_SH=$PWD/diy-part3.sh
REPO_PATH=$PWD
TZ=Asia/Shanghai

sudo rm -rf /etc/apt/sources.list.d/* /usr/share/dotnet /usr/local/lib/android /opt/ghc
sudo -E apt-get -qq update
sudo -E apt-get -qq install zip curl
echo installing depends
sudo -E apt-get -qq install $(curl -fsSL git.io/depends-ubuntu-2004)
echo finished installing depends
sudo -E apt-get -qq autoremove --purge
sudo -E apt-get -qq clean
sudo timedatectl set-timezone "$TZ"

git clone $REPO_URL -b $REPO_BRANCH openwrt

[ -e $FEEDS_CONF ] && cp -r $FEEDS_CONF openwrt/feeds.conf.default
chmod +x *.sh
cd openwrt
$DIY_P1_SH
./scripts/feeds update -a

./scripts/feeds install -a

[ -e $REPO_PATH/files ] && cp -r $REPO_PATH/files files
[ -e $CONFIG_FILE ] && cp $CONFIG_FILE .config
#sed -i s/.*=n//g .config
sed -i s/\#.*//g .config
$DIY_P2_SH
# $DIY_P3_SH
cp -r $REPO_PATH/banner package/base-files/files/etc/banner

make defconfig
make download -j8
find dl -size -1024c -exec ls -l {} \;
find dl -size -1024c -exec rm -f {} \;

echo -e "$(nproc) thread compile"
make --trace -j$(nproc) || make --trace -j1 || make --trace -j1 V=s
