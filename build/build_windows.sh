# ==============================================
# This tool is for Create windows zip
# ----------------------------------------------
# Auth:   Huailiang.Peng
# Data:   2019.08.26
# ==============================================
#!/bin/bash 


echo -e "打包参数: \n - uid:  "${uid}" \n - 分支: "${branch}" \n - 编译宏: "${macro}" \n"

#游戏工程目录#
PROJPATH=/Users/penghuailiang/Documents/projects/op_win

TARGET=win32_${uid}_${branch}.zip

cd `dirname $0`

sh clean_bundle.sh ${PROJPATH}/OPProject

sh git.sh ${PROJPATH} 

# sh xbuild2dll.sh ${PROJPATH}/OPProject/Assets/Lib

echo ${branch}"-"${uid}>${PROJPATH}/OPProject/Assets/Resources/packinfo.txt

cd ${PROJPATH}/OPProject/Win32/

rm -rf *.exe

rm -rf *_Data

echo $macro>${PROJPATH}/OPProject/Shell/macro.txt

$UNITY2019 -quit -batchmode -projectPath ${PROJPATH}/OPProject -logFile /tmp/win_debug_${uid}.log -executeMethod JenkinsBuild.BuildWin32 

if [ $? -ne 0 ]; then
	echo "打包失败"
	cd `dirname $0`
    sh build_log.sh win_debug_${uid}.log ${PROJPATH}/OPProject
    exit 1
fi

cd ${PROJPATH}/OPProject

rm -rf *.zip

zip  -qr  ${TARGET} Win32/ || { echo "not found build package, Sorry!"; cd `dirname $0`; sh build_log.sh win_debug_${uid}.log ${PROJPATH}/OPProject; exit 1; }

echo -e "zip finish\n"

cd `dirname $0`

sh upload.sh ${PROJPATH}/OPProject ${TARGET}

# sh sendmail.sh ${TARGET}

sh build_log.sh win_debug_${uid}.log ${PROJPATH}/OPProject
