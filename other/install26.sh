#! /bin/bash
HOME=~
EMACS_CONF_HOME=~/.emacs.d
PYTHON_PACKET_PATH=`python -c "from distutils.sysconfig import get_python_lib; print get_python_lib()"`
CMD_PATH=`pwd`/../
cd ~
HOME=`pwd`
EMACS_CONF_HOME=$HOME/.emacs.d
echo $PYTHON_PACKET_PATH
#echo "check python version, need 2.7"
#ret=`echo "$PYTHON_PACKET_PATH" | grep "2.7" | wc -l`
#if [ $ret -ne 1 ];then #cmp char* ge ne
#    echo "check python version failed"
#    exit 1
#fi
sudo yum install ncurses-devel.x86_64 -y
if [ $? -ne 0 ]; then
    echo "Error: failed!"
    exit 1
fi
sudo yum install unzip -y
if [ $? -ne 0 ]; then
    echo "Error: failed!"
    exit 1
fi

echo "download emacs..."
cd $CMD_PATH/../
sudo dnf install emacs -y

echo "install plug-in"
cd $CMD_PATH
cp -fr config/.emacs.d $HOME/
cp -fr config/.emacs $HOME/
cp -fr config/emacs26/.emacs.d $HOME/
cp -fr config/emacs26/.emacs $HOME/

echo "skip install python plug-in"
exit

cd plug-in
tar xzvf pymacs.tgz
sudo cp -rf pymacs/Pymacs pycomplete.py $PYTHON_PACKET_PATH

cd ropemacs
tar xzvf rope-0.9.4.tar.gz
cd rope-0.9.4
sudo python setup.py install
cd ..

tar xzvf ropemode-0.2.tar.gz
cd ropemode-0.2
sudo python setup.py install
cd ..

tar xzvf ropemacs-0.7.tar.gz
cd ropemacs-0.7
sudo python setup.py install
cd ..
cd $EMACS_CONF_HOME/install
echo "cscope ..."
sudo cp cscope_linux_15.8a/cscope cscope_linux_15.8a/cscope-indexer /usr/local/bin -f
sudo chmod +x /usr/local/bin/cscope
sudo chmod +x /usr/local/bin/cscope-indexer

echo "cedet &ecb ..."
tar xzvf cedet-1.0.tar.gz
cd cedet-1.0
make 
if [ $? -ne 0 ]; then
    echo "Error: failed!"
    exit 1
fi

cd ..
rm -rf ecb-2.40
unzip ecb-2.40.zip
#update highlight
cp ecb-face.el ecb-2.40  

echo "clang ..."
sudo yum install clang -y
if [ $? -ne 0 ]; then
    echo "Error: failed!"
    exit 1
fi
echo "*************************************"
echo "please remove erlang config from .emacs if don't need"
echo "please remove sigo config from .emacs if don't need"
echo "please copy these path to all-auto-complete-settgings.el for clang"
echo "*************************************"
echo "" | g++ -v -x c++ -E -


