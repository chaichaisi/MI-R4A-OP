
sudo rm -rf /etc/apt/sources.list.d/* /usr/share/dotnet /usr/local/lib/android /opt/ghc
sudo -E apt -y -qq update
sudo -E apt -y -qq install zip -y
sudo -E apt -y -qq install $(curl -fsSL git.io/depends-ubuntu-2004)
sudo -E apt -y -qq autoremove --purge
sudo -E apt -y -qq clean
sudo timedatectl set-timezone "Asia/Shanghai"

# git clone https://github.com/coolsnowwolf/lede -b master openwrt
git clone https://github.com/openwrt/openwrt -b master openwrt
ln -sf /workdir/openwrt openwrt

cp R4A.conf.default openwrt/feeds.conf.default
chmod +x diy-part1.sh
cd openwrt
../diy-part1.sh
./scripts/feeds update -a

./scripts/feeds install -a

cp ../R4A.config .config
chmod +x ../R4A.sh
../R4A.sh

chmod +x ../diy-part3.sh
cd ..
./diy-part3.sh
cd openwrt

make defconfig
make download -j8
find dl -size -1024c -exec ls -l {} \;
find dl -size -1024c -exec rm -f {} \;

echo -e "$(nproc) thread compile"
make --trace -j$(nproc) || make --trace -j1 || make --trace -j1 V=s