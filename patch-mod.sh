        #patch&mod
        sed -i "s/option hw_flow '1'/option hw_flow '0'/" package/feeds/luci/luci-app-turboacc/root/etc/config/turboacc
        sed -i "s/option sfe_flow '1'/option sfe_flow '0'/" package/feeds/luci/luci-app-turboacc/root/etc/config/turboacc
        sed -i "s/option sfe_bridge '1'/option sfe_bridge '0'/" package/feeds/luci/luci-app-turboacc/root/etc/config/turboacc
        sed -i "/dep.*INCLUDE_.*=n/d" package/feeds/luci/luci-app-turboacc/Makefile

        find . -type f -name nft-qos.config | xargs sed -i "s/option limit_enable '1'/option limit_enable '0'/"
        sed -i "/\/etc\/coremark\.sh/d" package/feeds/packages/coremark/coremark
        sed -i 's/192.168.1.1/192.168.2.1/' package/base-files/files/bin/config_generate
        sed -i 's/=1/=0/g' package/kernel/linux/files/sysctl-br-netfilter.conf

        sed -i '/DEPENDS/ s/$/ +libcap-bin/' `find . -type f -path '*/luci-app-openclash/Makefile'`
        sed -i '/DEPENDS+/ s/$/ +wsdd2/' `find . -type f -path '*/ksmbd-tools/Makefile'`
        
        sed -i "s/enable '0'/enable '1'/" `find feeds/ -type f -name oled | grep config`
        sed -i 's/1400000/1450000/' target/linux/rockchip/patches-5.4/991-arm64-dts-rockchip-add-more-cpu-operating-points-for.patch
        truncate -s-1 package/feeds/luci/luci-app-cpufreq/root/etc/config/cpufreq
        echo -e "\toption governor0 'schedutil'" >> package/feeds/luci/luci-app-cpufreq/root/etc/config/cpufreq
        echo -e "\toption minfreq0 '816000'" >> package/feeds/luci/luci-app-cpufreq/root/etc/config/cpufreq
        echo -e "\toption maxfreq0 '1512000'\n" >> package/feeds/luci/luci-app-cpufreq/root/etc/config/cpufreq
        
        wget https://github.com/coolsnowwolf/lede/raw/757e42d70727fe6b937bb31794a9ad4f5ce98081/target/linux/rockchip/config-default -NP target/linux/rockchip/
        wget https://github.com/coolsnowwolf/lede/commit/f341ef96fe4b509a728ba1281281da96bac23673.patch
        git apply f341ef96fe4b509a728ba1281281da96bac23673.patch
        rm f341ef96fe4b509a728ba1281281da96bac23673.patch
        
        sed -i '/182.140.223.146/d' scripts/download.pl
        sed -i '/\.cn\//d' scripts/download.pl
        sed -i '/tencent/d' scripts/download.pl
        
        #SWAP LAN WAN 满足千兆场景
        sed -i 's,"eth1" "eth0","eth0" "eth1",g' target/linux/rockchip/armv8/base-files/etc/board.d/02_network
        sed -i "s,'eth1' 'eth0','eth0' 'eth1',g" target/linux/rockchip/armv8/base-files/etc/board.d/02_network
        
		#Change to 5.10
        #sed -i 's/KERNEL_PATCHVER=5.4/KERNEL_PATCHVER=5.10/g' target/linux/rockchip/Makefile
        
		#jd-dailybonus 更新
        git clone --depth 1 https://github.com/jerrykuku/node-request.git package/new/node-request
        svn co -r131 https://github.com/jerrykuku/luci-app-jd-dailybonus/trunk package/new/luci-app-jd-dailybonus
        pushd package/new/luci-app-jd-dailybonus
        sed -i 's/wget-ssl/wget/g' root/usr/share/jd-dailybonus/newapp.sh luasrc/controller/jd-dailybonus.lua
        popd
        rm -rf ./package/new/luci-app-jd-dailybonus/root/usr/share/jd-dailybonus/JD_DailyBonus.js
        wget -P package/new/luci-app-jd-dailybonus/root/usr/share/jd-dailybonus/ https://github.com/NobyDa/Script/raw/master/JD-DailyBonus/JD_DailyBonus.js
