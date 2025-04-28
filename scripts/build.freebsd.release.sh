#!/usr/local/bin/bash
set -xe

pkg install pkgconf rapidjson libevent pcre2 yaml-cpp

[ ! -d quickjspp ] && git clone https://github.com/ftk/quickjspp --depth=1
cd quickjspp
cmake -DCMAKE_BUILD_TYPE=Release .
make quickjs -j4
install -d /usr/local/lib/quickjs/
install -m644 quickjs/libquickjs.a /usr/local/lib/quickjs/
install -d /usr/local/include/quickjs/
install -m644 quickjs/quickjs.h quickjs/quickjs-libc.h /usr/local/include/quickjs/
install -m644 quickjspp.hpp /usr/local/include/
cd ..

[ ! -d libcron ] && git clone https://github.com/PerMalmberg/libcron --depth=1
cd libcron
git submodule update --init
cmake -DCMAKE_BUILD_TYPE=Release .
make libcron -j4
install -m644 libcron/out/Release/liblibcron.a /usr/local/lib/
install -d /usr/local/include/libcron/
install -m644 libcron/include/libcron/* /usr/local/include/libcron/
install -d /usr/local/include/date/
install -m644 libcron/externals/date/include/date/* /usr/local/include/date/

cd ..


git clone https://github.com/ToruNiina/toml11 --branch="v4.3.0" --depth=1
cd toml11
cmake -DCMAKE_CXX_STANDARD=11 .
make install -j4 > /dev/null
cd ..


cp /usr/local/lib/libevent.a .
cp /usr/lib/libz.a .
cp /usr/local/lib/libpcre2-8.a .

cmake -DCMAKE_BUILD_TYPE=Release .
make -j4
rm subconverter

c++ -Xlinker -unexported_symbol -o base/subconverter $(find CMakeFiles/subconverter.dir/src/ -name "*.o") $(find . -name "*.a") -lpthread -L/usr/local/lib -lyaml-cpp -lcurl -O3

cd base
chmod +rx subconverter
chmod +r ./*
cd ..
mv base subconverter



set +xe
